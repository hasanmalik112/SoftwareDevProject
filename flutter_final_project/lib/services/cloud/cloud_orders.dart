import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'cloud_storage_constants.dart';

@immutable
class CloudOrder {
  final String documentId;
  final String ownerUserId;
  final String productname;
  final int orderQuantity;
  final int orderAmount;
  final String orderStatus;
  const CloudOrder(
      {required this.documentId,
      required this.ownerUserId,
      required this.productname,
      required this.orderAmount,
      required this.orderStatus,
      required this.orderQuantity});

  CloudOrder.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        productname = snapshot.data()[orderNameField] as String,
        orderAmount = snapshot.data()[orderAmountField] as int,
        orderStatus = snapshot.data()[orderStatusField] as String,
        orderQuantity = snapshot.data()[orderQuantityField] as int;
}
