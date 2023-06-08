import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'cloud_storage_constants.dart';

@immutable
class CloudItem {
  final String documentId;
  final String ownerUserId;
  final String name;
  final String barcode;
  final int quantity;
  final int price;
  const CloudItem(
      {required this.documentId,
      required this.ownerUserId,
      required this.name,
      required this.barcode,
      required this.price,
      required this.quantity});

  CloudItem.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        name = snapshot.data()[nameField] as String,
        barcode = snapshot.data()[barcodeNumField] as String,
        price = snapshot.data()[priceField] as int,
        quantity = snapshot.data()[quantityField] as int;
}
