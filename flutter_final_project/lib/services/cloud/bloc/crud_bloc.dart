import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_final_project/services/cloud/cloud_transaction.dart';
import 'package:flutter_final_project/services/cloud/firebase_cloud_storage_transactions.dart';

import 'crud_event.dart';
import 'crud_state.dart';

class CloudStorageBloc extends Bloc<CloudStorageEvent, CloudStorageState> {
  final FirebaseFirestore _firestore;

  CloudStorageBloc()
      : _firestore = FirebaseFirestore.instance,
        super(CloudStorageInitial(isLoading: true));

  Stream<CloudStorageState> mapEventToState(CloudStorageEvent event) async* {
    if (event is DeleteItemEvent) {
      yield* _mapDeleteItemEventToState(event);
    } else if (event is UpdateItemEvent) {
      yield* _mapUpdateItemEventToState(event);
    } else if (event is LoadAllItemsEvent) {
      yield* _mapLoadAllItemsEventToState(event);
    } else if (event is CreateNewItemEvent) {
      yield* _mapCreateNewItemEventToState(event);
    }
  }

  Stream<CloudStorageState> _mapDeleteItemEventToState(
      DeleteItemEvent event) async* {
    try {
      await _firestore.collection('items').doc(event.documentId).delete();
      yield DeleteItemSuccess(isLoading: false);
    } catch (_) {
      yield DeleteItemFailure(isLoading: false);
    }
  }

  Stream<CloudStorageState> _mapUpdateItemEventToState(
      UpdateItemEvent event) async* {
    try {
      await _firestore.collection('items').doc(event.documentId).update({
        nameField: event.name,
        quantityField: event.quantity,
        priceField: event.price,
      });
      yield UpdateItemSuccess(isLoading: false);
    } catch (_) {
      yield UpdateItemFailure(isLoading: false);
    }
  }

  Stream<CloudStorageState> _mapLoadAllItemsEventToState(
      LoadAllItemsEvent event) async* {
    yield LoadAllItemsInProgress(isLoading: true);
    try {
      final snapshot = await _firestore
          .collection('items')
          .where(ownerUserIdFieldName, isEqualTo: event.ownerUserId)
          .get();
      final items =
          snapshot.docs.map((doc) => CloudItem.fromSnapshot(doc)).toList();
      yield LoadAllItemsSuccess(items);
    } catch (_) {
      yield LoadAllItemsFailure(isLoading: false);
    }
  }

  Stream<CloudStorageState> _mapCreateNewItemEventToState(
      CreateNewItemEvent event) async* {
    try {
      final document = await _firestore.collection('items').add({
        ownerUserIdFieldName: event.ownerUserId,
        nameField: event.name,
        quantityField: event.quantity,
        priceField: event.price,
      });
      final fetchedItem =
          await document.get() as QueryDocumentSnapshot<Map<String, dynamic>>;
      final newItem = CloudItem.fromSnapshot(fetchedItem);
      yield CreateNewItemSuccess(newItem);
    } catch (_) {
      yield CreateNewItemFailure(isLoading: false);
    }
  }
}

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final FirebaseCloudStorageTransaction _transactionService =
      FirebaseCloudStorageTransaction();

  TransactionBloc() : super(TransactionInitial());

  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is FetchTransactions) {
      yield* _mapFetchTransactionsToState(event);
    } else if (event is CreateTransaction) {
      yield* _mapCreateTransactionToState(event);
    }
  }

  Stream<TransactionState> _mapFetchTransactionsToState(
      FetchTransactions event) async* {
    yield TransactionLoading();
    try {
      final transactions =
          _transactionService.allTransactions(ownerUserId: event.ownerUserId);
      yield TransactionLoaded(transactions.toList() as List<CloudTransaction>);
    } catch (e) {
      yield TransactionError('Failed to fetch transactions');
    }
  }

  Stream<TransactionState> _mapCreateTransactionToState(
      CreateTransaction event) async* {
    yield TransactionLoading();
    try {
      final newTransaction = await _transactionService.createNewTransaction(
        ownerUserId: event.ownerUserId,
        name: event.name,
        transactionamount: event.transactionAmount,
        quantitysold: event.quantitySold,
        timestamp: Timestamp.now(),
      );
      yield TransactionLoaded([newTransaction]);
    } catch (e) {
      yield TransactionError('Failed to create transaction');
    }
  }
}
