import 'package:equatable/equatable.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/services/cloud/cloud_transaction.dart';

abstract class CloudStorageState {
  final bool isLoading;
  final String? loadingText;
  const CloudStorageState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class CloudStorageInitial extends CloudStorageState {
  CloudStorageInitial({required super.isLoading});
}

class DeleteItemSuccess extends CloudStorageState {
  DeleteItemSuccess({required super.isLoading});
}

class DeleteItemFailure extends CloudStorageState {
  DeleteItemFailure({required super.isLoading});
}

class UpdateItemSuccess extends CloudStorageState {
  UpdateItemSuccess({required super.isLoading});
}

class UpdateItemFailure extends CloudStorageState {
  UpdateItemFailure({required super.isLoading});
}

class LoadAllItemsInProgress extends CloudStorageState {
  LoadAllItemsInProgress({required super.isLoading});
}

class LoadAllItemsSuccess extends CloudStorageState {
  final List<CloudItem> items;

  LoadAllItemsSuccess(this.items) : super(isLoading: false);
}

class LoadAllItemsFailure extends CloudStorageState {
  LoadAllItemsFailure({required super.isLoading});
}

class CreateNewItemSuccess extends CloudStorageState {
  final CloudItem item;

  CreateNewItemSuccess(this.item) : super(isLoading: false);
}

class CreateNewItemFailure extends CloudStorageState {
  CreateNewItemFailure({required super.isLoading});
}

abstract class TransactionState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<CloudTransaction> transactions;

  TransactionLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
