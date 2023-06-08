import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/services/cloud/cloud_orders.dart';
import 'package:flutter_final_project/utilities/dialogs/delete_dialog.dart';

typedef OrderCallback = void Function(CloudOrder order);

class OrderListView extends StatelessWidget {
  final Iterable<CloudOrder> orders;
  final OrderCallback onDeleteorder;
  final OrderCallback onTap;

  const OrderListView({
    Key? key,
    required this.orders,
    required this.onDeleteorder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              onTap(order);
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2),
                borderRadius: BorderRadius.circular(20)),
            title: Text(
              order.documentId,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: ${order.orderStatus}',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                    height: 4), // Add spacing between price and quantity
                Text(
                  'Total: ${order.orderAmount}',
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
                  onDeleteorder(order);
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
