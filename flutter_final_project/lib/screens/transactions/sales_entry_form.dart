import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/constants/routes.dart';
import 'package:flutter_final_project/helpers/myappbar.dart';
import 'package:flutter_final_project/page_navigation/bloc/page_nav_bloc.dart';
import 'package:flutter_final_project/services/auth/auth_service.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/services/cloud/cloud_transaction.dart';
import 'package:flutter_final_project/services/cloud/firebase_cloud_storage_transactions.dart';
import 'package:flutter_final_project/utilities/dialogs/low_inventory_error.dart';
import 'package:flutter_final_project/utilities/generics/get_arguments.dart';

class SalesEntry extends StatefulWidget {
  const SalesEntry({Key? key}) : super(key: key);

  @override
  State<SalesEntry> createState() => _SalesEntryState();
}

class _SalesEntryState extends State<SalesEntry> {
  CloudItem? _item;
  CloudTransaction? _transaction;
  late bool isUpdate;
  late final FirebaseCloudStorageTransaction _transactionService;
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _transactionamountController;

  @override
  void initState() {
    _transactionService = FirebaseCloudStorageTransaction();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _transactionamountController = TextEditingController();
    isUpdate = false;
    super.initState();
  }

  void _textControllerListener() async {
    final transaction = _transaction;
    if (transaction == null) {
      return;
    }

    final name = _nameController.text;
    final quantitySoldText = _quantityController.text;
    final transactionAmountText = _transactionamountController.text;

    int quantitySold = 0;
    if (quantitySoldText.isNotEmpty) {
      try {
        quantitySold = int.parse(quantitySoldText);
      } catch (e) {
        // Handle parsing error for quantitySold
        print('Error parsing quantitySold: $e');
        return;
      }
    }

    int transactionAmount = 0;
    if (transactionAmountText.isNotEmpty) {
      try {
        transactionAmount = int.parse(transactionAmountText);
      } catch (e) {
        // Handle parsing error for transactionAmount
        print('Error parsing transactionAmount: $e');
        return;
      }
    }

    await _transactionService.updateTransaction(
      documentId: transaction.documentId,
      name: name,
      quantitysold: quantitySold,
      transactionamount: transactionAmount,
      timestamp: Timestamp.now(),
    );
    _item = await _transactionService.getItemByName(_nameController.text);
    //print(_item);

    if (_item != null && isUpdate == false) {
      isUpdate = true;
      if (_item!.quantity < 50) {
        return showLowInventoryDialog(context);
      } else {
        final updatedQuantity = _item!.quantity - quantitySold;
        await _transactionService.updateItemQuantity(
            _item!.name, updatedQuantity);
      }
    }
    Future.delayed(const Duration(seconds: 1), () {
      isUpdate = false;
      print("Inside delayed function: $isUpdate ");
    }).then((_) {
      print("After delay: $isUpdate ");
    });
  }

  void _setupTextControllerListener() {
    _nameController.removeListener(_textControllerListener);
    _nameController.addListener(_textControllerListener);
    _transactionamountController.removeListener(_textControllerListener);
    _transactionamountController.addListener(_textControllerListener);
    _quantityController.removeListener(_textControllerListener);
    _quantityController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _transactionamountController.dispose();
    _quantityController.dispose();
    _saveTransactionIfNameNotEmpty();
    _deleteTransactionIfFieldsAreEmpty();
    super.dispose();
  }

  Future<CloudTransaction> createOrGetExistingTransaction(
      BuildContext context) async {
    final widgetTransaction = context.getArgument<CloudTransaction>();

    if (widgetTransaction != null) {
      _transaction = widgetTransaction;
      _nameController.text = widgetTransaction.productname;
      _transactionamountController.text =
          widgetTransaction.transactionamount.toString();
      _quantityController.text = widgetTransaction.quantitysold.toString();
      _item = await _transactionService
          .getItemByName(widgetTransaction.productname);
      return widgetTransaction;
    }

    final existingTransaction = _transaction;
    if (existingTransaction != null) {
      return existingTransaction;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;

    final newTransaction = await _transactionService.createNewTransaction(
      ownerUserId: userId,
      name: '',
      transactionamount: 0,
      quantitysold: 0,
      timestamp: Timestamp.now(),
    );
    _transaction = newTransaction;
    return newTransaction;
  }

  void _deleteTransactionIfFieldsAreEmpty() {
    final transaction = _transaction;
    final name = _nameController.text;
    final transactionAmount = _transactionamountController.text;
    final quantitySold = _quantityController.text;

    if (name.isEmpty &&
        transactionAmount.isEmpty &&
        quantitySold.isEmpty &&
        transaction != null) {
      _transactionService.deleteTransaction(documentId: transaction.documentId);
    }
  }

  void _saveTransactionIfNameNotEmpty() async {
    final transaction = _transaction;
    final name = _nameController.text;
    final transactionAmount = int.parse(_transactionamountController.text);
    final quantitySold = int.parse(_quantityController.text);

    if (transaction != null && name.isNotEmpty) {
      await _transactionService.updateTransaction(
        documentId: transaction.documentId,
        name: name,
        transactionamount: transactionAmount,
        quantitysold: quantitySold,
        timestamp: Timestamp.now(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageNavBloc>(
          create: (BuildContext context) => PageNavBloc(),
        ),
      ],
      child: Scaffold(body: blocBody(context)),
    );
  }

  Widget blocBody(BuildContext buildcontext) {
    return BlocConsumer<PageNavBloc, PageNavState>(
      listener: (context, state) {
        if (state is PressedBackButtonState) {
          //_deleteItemIfNameIsEmpty();
          Navigator.of(context).pop();
        } else if (state is PressedAddTransactionViewState) {
          Navigator.of(context).pushNamed(transactionViewRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Selling Point'),
            centerTitle: true,
            backgroundColor: appBarColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _deleteTransactionIfFieldsAreEmpty();
                //Navigator.of(context).pop();
                BlocProvider.of<PageNavBloc>(context)
                    .add(PressedBackButtonEvent());
              },
            ),
          ),
          body: FutureBuilder(
            future: createOrGetExistingTransaction(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Item Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'No. of Items to be sold',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _transactionamountController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Total Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pushNamed(
                          //   transactionViewRoute,
                          // );
                          BlocProvider.of<PageNavBloc>(context)
                              .add(PressedAddTransactionEvent());
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(appBarColor),
                        ),
                        child: const Text('Make Sale!'),
                      ),
                    ],
                  );
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }
}
