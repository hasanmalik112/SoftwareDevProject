import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NotesService {
  Database? _db;

  List<DatabaseNotes> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamcontroller = StreamController<List<DatabaseNotes>>.broadcast(
      onListen: () {
        _notesStreamcontroller.sink.add(_notes);
      },
    );
  }
  factory NotesService() => _shared;

  late final StreamController<List<DatabaseNotes>> _notesStreamcontroller;

  Stream<List<DatabaseNotes>> get allNotes => _notesStreamcontroller.stream;

  Future<DataBaseUser> getOrcreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNote();
    _notes = allNotes.toList();
    _notesStreamcontroller.add(_notes);
  }

  Future<DatabaseNotes> updateNote({
    required DatabaseNotes notes,
    required String text,
  }) async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    await getNote(id: notes.id);
    final updatesCount = await db.update(notesTable, {
      textColoum: text,
      iSwC: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final updatedNote = await getNote(id: notes.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamcontroller.add(_notes);
      return updatedNote;
    }
  }

  Future<Iterable<DatabaseNotes>> getAllNote() async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final notes = await db.query(
      notesTable,
    );
    return notes.map((notesRow) => DatabaseNotes.fromRow(notesRow));
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNotesException();
    } else {
      final note = DatabaseNotes.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamcontroller.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final numofDeletion = await db.delete(notesTable);
    _notes = [];
    _notesStreamcontroller.add(_notes);
    return numofDeletion;
  }

  Future<void> deleteNotes({required int id}) async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamcontroller.add(_notes);
    }
  }

  Future<DatabaseNotes> createNotes({required DataBaseUser owner}) async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }
    const text = '';
    final notesId = await db.insert(notesTable, {
      userIdColoum: owner.id,
      textColoum: text,
      iSwC: 1,
    });
    final note = DatabaseNotes(
      id: notesId,
      userId: owner.id,
      text: text,
      isSyncedwithCloud: true,
    );
    _notes.add(note);
    _notesStreamcontroller.add(_notes);
    return note;
  }

  Future<DataBaseUser> getUser({required String email}) async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future<DataBaseUser> createUser({required String email}) async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId = await db.insert(
      userTable,
      {emailColoum: email.toLowerCase()},
    );

    return DataBaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureIsDbOpen();
    final db = _getDatabaseorThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPaths = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPaths.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNotesTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> _ensureIsDbOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseAlreadyOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Database _getDatabaseorThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseAlreadyOpenException();
    } else {
      return db;
    }
  }
}

@immutable
class DataBaseUser {
  final int id;
  final String email;

  const DataBaseUser({
    required this.id,
    required this.email,
  });

  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColoum] as int,
        email = map[emailColoum] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedwithCloud;

  DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedwithCloud,
  });

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColoum] as int,
        userId = map[userIdColoum] as int,
        text = map[textColoum] as String,
        isSyncedwithCloud = (map[iSwC] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Notes, id = $id, userId = $userId, text = $text, isSyncedwithcloud = $isSyncedwithCloud';

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const createUserTable = ''' CREATE TABLE IF NOT EXIST "user" (
          "ID"	INTEGER,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("ID" AUTOINCREMENT)
        ); 
      ''';

const createNotesTable = ''' CREATE TABLE IF NOT EXIST "Notes" (
         "ID"	INTEGER NOT NULL,
         "user_id"	INTEGER NOT NULL,
         "text"	TEXT,
          "is_synced_with_server"	INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY("user_id") REFERENCES "user"("ID"),
          PRIMARY KEY("ID")
         );
          ''';

const dbName = 'notes.db';
const userTable = 'user';
const notesTable = 'note';
const idColoum = 'id';
const emailColoum = 'email';
const userIdColoum = 'user_id';
const textColoum = 'text';
const iSwC = 'is_synced_with_cloud';
