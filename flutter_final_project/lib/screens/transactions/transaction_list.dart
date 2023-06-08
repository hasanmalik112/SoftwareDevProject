import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/cloud/cloud_transaction.dart';
import 'package:flutter_final_project/utilities/dialogs/delete_dialog.dart';

typedef TransactionCallback = void Function(CloudTransaction transaction);

class TransactionListView extends StatelessWidget {
  final Iterable<CloudTransaction> transactions;
  final TransactionCallback onDeletetransaction;
  final TransactionCallback onTap;

  const TransactionListView({
    Key? key,
    required this.transactions,
    required this.onDeletetransaction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              onTap(transaction);
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2),
                borderRadius: BorderRadius.circular(20)),
            title: Text(
              transaction.productname,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount: ${transaction.transactionamount}',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${transaction.quantitysold}',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            dense: true,
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeletetransaction(transaction);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        );
      },
    );
  }
}
