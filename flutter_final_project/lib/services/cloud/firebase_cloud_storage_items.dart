import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_final_project/services/cloud/cloud_storage_exception.dart';

class FirebaseCloudStorageItem {
  final items = FirebaseFirestore.instance.collection('items');

  Future<void> deleteItem({required String documentId}) async {
    try {
      await items.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteItemException();
    }
  }

  // Future<CloudItem> getItemById(String itemId) async {
  //   final snapshot = await items.where()
  // }

  // Future<void> updateItemQuantity(String itemId, int quantity) async {
  //   await FirebaseFirestore.instance
  //       .collection('items')
  //       .doc(itemId)
  //       .update({'quantity': quantity});
  // }

  Future<CloudItem?> getItemByName(String name) async {
    final snapshot = await items.where('name', isEqualTo: name).get();
    if (snapshot.docs.isNotEmpty) {
      final item = CloudItem.fromSnapshot(snapshot.docs.first);
      return item;
    }
    return null;
  }

  Future<void> updateItem({
    required String documentId,
    required String name,
    required String barcode,
    required int quantity,
    required int price,
  }) async {
    try {
      await items.doc(documentId).update({
        nameField: name,
        quantityField: quantity,
        priceField: price,
        barcodeNumField: barcode,
      });
    } catch (e) {
      throw CouldNotUpdateItemException();
    }
  }

  Stream<Iterable<CloudItem>> allItems({required String ownerUserId}) {
    final allItems = items
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudItem.fromSnapshot(doc)));
    return allItems;
  }

  Future<CloudItem> createNewItem({
    required String ownerUserId,
    required String name,
    required int quantity,
    required int price,
  }) async {
    final document = await items.add({
      ownerUserIdFieldName: ownerUserId,
      nameField: name,
      quantityField: quantity,
      priceField: price,
    });
    final fetchedItem = await document.get();
    return CloudItem(
      documentId: fetchedItem.id,
      ownerUserId: ownerUserId,
      name: '',
      price: 0,
      quantity: 0,
      barcode: '',
    );
  }

  static final FirebaseCloudStorageItem _shared =
      FirebaseCloudStorageItem._sharedInstance();
  FirebaseCloudStorageItem._sharedInstance();
  factory FirebaseCloudStorageItem() => _shared;
}
