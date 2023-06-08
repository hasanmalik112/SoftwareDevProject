import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final_project/services/cloud/cloud_orders.dart';
import 'package:flutter_final_project/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_final_project/services/cloud/cloud_storage_exception.dart';

class FirebaseCloudStorageOrders {
  final orders = FirebaseFirestore.instance.collection('orders');

  Future<void> deleteOrder({required String documentId}) async {
    try {
      await orders.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteItemException();
    }
  }

  Future<CloudOrder?> getOrdersByName(String productName) async {
    final snapshot = await orders.where('name', isEqualTo: productName).get();
    if (snapshot.docs.isNotEmpty) {
      final order = CloudOrder.fromSnapshot(snapshot.docs.first);
      return order;
    }
    return null;
  }

  Future<void> updateOrder({
    required String documentId,
    required String productName,
    required String orderStatus,
    required int orderQuantity,
    required int orderAmount,
  }) async {
    try {
      await orders.doc(documentId).update({
        orderNameField: productName,
        orderQuantityField: orderQuantity,
        orderAmountField: orderAmount,
        orderStatusField: orderStatus,
      });
    } catch (e) {
      throw CouldNotUpdateItemException();
    }
  }

  Stream<Iterable<CloudOrder>> allOrders({required String ownerUserId}) {
    final allorders = orders
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudOrder.fromSnapshot(doc)));
    return allorders;
  }

  Future<CloudOrder> createNewOrder({
    required String ownerUserId,
    required String name,
    required int quantity,
    required int orderAmount,
    required String orderStatus,
  }) async {
    final document = await orders.add({
      ownerUserIdFieldName: ownerUserId,
      productNameField: name,
      orderQuantityField: quantity,
      orderAmountField: orderAmount,
      orderStatusField: orderStatus
    });
    final fetchedOrder = await document.get();
    return CloudOrder(
      documentId: fetchedOrder.id,
      ownerUserId: ownerUserId,
      productname: name,
      orderAmount: orderAmount,
      orderQuantity: quantity,
      orderStatus: orderStatus,
    );
  }

  static final FirebaseCloudStorageOrders _shared =
      FirebaseCloudStorageOrders._sharedInstance();
  FirebaseCloudStorageOrders._sharedInstance();
  factory FirebaseCloudStorageOrders() => _shared;
}
