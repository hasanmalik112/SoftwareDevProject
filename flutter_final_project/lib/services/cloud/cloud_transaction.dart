import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'cloud_storage_constants.dart';

@immutable
class CloudTransaction {
  final String documentId;
  final String ownerUserId;
  final String productname;
  final int transactionamount;
  final int quantitysold;
  final Timestamp timestamp;
  const CloudTransaction(
      {required this.documentId,
      required this.ownerUserId,
      required this.productname,
      required this.transactionamount,
      required this.quantitysold,
      required this.timestamp});

  CloudTransaction.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        productname = snapshot.data()[productNameField] as String,
        transactionamount = snapshot.data()[transactionAmountField] as int,
        quantitysold = snapshot.data()[quantitySoldField] as int,
        timestamp = snapshot.data()[timestampField] as Timestamp;
}
