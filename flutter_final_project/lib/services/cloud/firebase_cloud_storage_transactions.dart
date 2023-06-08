import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_final_project/services/cloud/cloud_storage_exception.dart';
import 'package:flutter_final_project/services/cloud/cloud_transaction.dart';

class FirebaseCloudStorageTransaction {
  final transactions = FirebaseFirestore.instance.collection('transactions');
  final items = FirebaseFirestore.instance.collection('items');

  Future<void> deleteTransaction({required String documentId}) async {
    try {
      await transactions.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteTransactionException();
    }
  }

  Future<CloudItem?> getItemByName(String name) async {
    final snapshot = await items.where('name', isEqualTo: name).get();
    if (snapshot.docs.isNotEmpty) {
      final item = CloudItem.fromSnapshot(snapshot.docs.first);
      return item;
    }
    return null;
  }

  Future<void> updateItemQuantity(String name, int quantity) async {
    print(quantity);
    print(name);
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('name', isEqualTo: name)
        .get();

    final documents = querySnapshot.docs;
    if (documents.isNotEmpty) {
      final document = documents[0];
      final reference = document.reference;
      await reference.update({'quantity': quantity});
    }
  }

  Future<void> updateTransaction({
    required String documentId,
    required String name,
    required int quantitysold,
    required int transactionamount,
    required Timestamp timestamp,
  }) async {
    try {
      await transactions.doc(documentId).update({
        productNameField: name,
        quantitySoldField: quantitysold,
        transactionAmountField: transactionamount,
        timestampField: Timestamp.now(),
      });
    } catch (e) {
      throw CouldNotUpdateItemException();
    }
  }

  Stream<Iterable<CloudTransaction>> allTransactions(
      {required String ownerUserId}) {
    final allTransaction = transactions
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudTransaction.fromSnapshot(doc)));
    return allTransaction;
  }

  // Stream<Iterable<CloudTransaction>> allTransactions(
  //     {required String ownerUserId}) {
  //   final allTransaction = FirebaseFirestore.instance
  //       .collection('transactions')
  //       //.where('user_id', isEqualTo: 'pRBHnAszl6aXb9EG5PLiyHGWz8C3')
  //       .snapshots()
  //       .map((querySnapshot) => querySnapshot.docs
  //           .map((doc) => CloudTransaction.fromSnapshot(doc)));

  //   allTransaction.listen((transactionData) {
  //     transactionData.forEach((transaction) {
  //       print('Transaction data:');
  //       print('ID: ${transaction.documentId}');
  //       print('Amount: ${transaction.transactionamount}');
  //       print('Description: ${transaction.quantitysold}');
  //       // Print other properties as needed

  //       // Insert blank line for separation
  //       print('');
  //     });
  //   });

  //   return allTransaction;
  // }

  Future<CloudTransaction> createNewTransaction({
    required String ownerUserId,
    required String name,
    required int transactionamount,
    required int quantitysold,
    required Timestamp timestamp,
  }) async {
    final document = await transactions.add({
      ownerUserIdFieldName: ownerUserId,
      productNameField: name,
      transactionAmountField: transactionamount,
      quantitySoldField: quantitysold,
      timestampField: timestamp,
    });
    final fetchedTransaction = await document.get();
    return CloudTransaction(
        documentId: fetchedTransaction.id,
        ownerUserId: ownerUserId,
        productname: name,
        transactionamount: transactionamount,
        quantitysold: quantitysold,
        timestamp: Timestamp.now());
  }

  static final FirebaseCloudStorageTransaction _shared =
      FirebaseCloudStorageTransaction._sharedInstance();
  FirebaseCloudStorageTransaction._sharedInstance();
  factory FirebaseCloudStorageTransaction() => _shared;
}
