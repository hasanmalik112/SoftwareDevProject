import 'package:flutter/material.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/utilities/dialogs/delete_dialog.dart';

typedef ItemCallback = void Function(CloudItem item);

class ItemsListView extends StatelessWidget {
  final Iterable<CloudItem> items;
  final ItemCallback onDeleteitem;
  final ItemCallback onTap;

  const ItemsListView({
    Key? key,
    required this.items,
    required this.onDeleteitem,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              onTap(item);
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2),
                borderRadius: BorderRadius.circular(20)),
            title: Text(
              item.name,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price: ${item.price}',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                    height: 4), // Add spacing between price and quantity
                Text(
                  'Quantity: ${item.quantity}',
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
                  onDeleteitem(item);
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
