import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Dashboard {
  Future<String> totalSalesAmount() async {
    int amount = 0;
    final QuerySnapshot =
        await FirebaseFirestore.instance.collection("transations").get();

    String queryAmount;
    QuerySnapshot.docs.map((doc) => {
          queryAmount = (doc.data()
              as Map<String, dynamic>)["transactionamount"] as String,
          amount += int.parse(queryAmount)
        });

    return amount.toString();
  }

  Future<String> totalNumberOfTransactions() async {
    final int count = await FirebaseFirestore.instance
        .collection('transactions')
        .snapshots()
        .length;
    return count.toString();
  }

  Future<String> totalProductsinInventory() async {
    final int productsCount =
        await FirebaseFirestore.instance.collection('items').snapshots().length;
    return productsCount.toString();
  }
}
