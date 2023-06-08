import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/helpers/myappbar.dart';
import 'package:flutter_final_project/page_navigation/bloc/page_nav_bloc.dart';
import 'package:flutter_final_project/screens/transactions/transaction_list.dart';
import 'package:flutter_final_project/services/cloud/cloud_transaction.dart';
import '../../constants/routes.dart';
import '../../services/auth/auth_service.dart';
import '../../services/cloud/firebase_cloud_storage_transactions.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  late final FirebaseCloudStorageTransaction _transactionService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _transactionService = FirebaseCloudStorageTransaction();
    super.initState();
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
          Navigator.of(buildcontext).pushNamed(mainPageRoute);
        } else if (state is PressedMakeTransactionViewState) {
          Navigator.of(context).pushNamed(salesEntryRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text('Transaction History'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                //Navigator.of(context).pop();
                BlocProvider.of<PageNavBloc>(context)
                    .add(PressedBackButtonEvent());
              },
            ),
          ),
          body: StreamBuilder(
            stream: _transactionService.allTransactions(
              ownerUserId: userId,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allTransactions =
                        snapshot.data as Iterable<CloudTransaction>;
                    return TransactionListView(
                      transactions: allTransactions,
                      onDeletetransaction: (transaction) async {
                        await _transactionService.deleteTransaction(
                            documentId: transaction.documentId);
                      },
                      onTap: (transaction) {
                        Navigator.of(context).pushNamed(
                          salesEntryRoute,
                          arguments: transaction,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    // Handle the error case here
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
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
