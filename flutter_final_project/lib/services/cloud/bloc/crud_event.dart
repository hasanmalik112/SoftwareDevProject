import 'package:equatable/equatable.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';

abstract class CloudStorageEvent {}

class DeleteItemEvent extends CloudStorageEvent {
  final String documentId;

  DeleteItemEvent(this.documentId);
}

class UpdateItemEvent extends CloudStorageEvent {
  final String documentId;
  final String name;
  final int quantity;
  final int price;

  UpdateItemEvent(this.documentId, this.name, this.quantity, this.price,
      {required CloudItem item});
}

class LoadAllItemsEvent extends CloudStorageEvent {
  final String ownerUserId;

  LoadAllItemsEvent(this.ownerUserId);
}

class CreateNewItemEvent extends CloudStorageEvent {
  final String ownerUserId;
  final String name;
  final int quantity;
  final int price;

  CreateNewItemEvent(this.ownerUserId, this.name, this.quantity, this.price);
}

abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTransactions extends TransactionEvent {
  final String ownerUserId;

  FetchTransactions(this.ownerUserId);

  @override
  List<Object> get props => [ownerUserId];
}

class CreateTransaction extends TransactionEvent {
  final String ownerUserId;
  final String name;
  final int transactionAmount;
  final int quantitySold;

  CreateTransaction({
    required this.ownerUserId,
    required this.name,
    required this.transactionAmount,
    required this.quantitySold,
  });

  @override
  List<Object> get props =>
      [ownerUserId, name, transactionAmount, quantitySold];
}
