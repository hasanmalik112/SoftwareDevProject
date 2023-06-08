import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:d_chart/d_chart.dart';

class ProductChart extends StatelessWidget {
  ProductChart({Key? key}) : super(key: key);

  final streamChart = FirebaseFirestore.instance
      .collection('item')
      .snapshots(includeMetadataChanges: true);

  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Live Chart"),
    //     centerTitle: true,
    //   ),
    // body:
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        StreamBuilder(
            stream: streamChart,
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              if (snapshot.data == null) {
                return const Text("Empty");
              }

              List listChart = snapshot.data!.docs.map((e) {
                return {
                  'domain': e.data()['name'],
                  'measure': e.data()['quantity']
                };
              }).toList();
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: DChartBar(
                  barColor: (barData, index, id) => Colors.purple,
                  axisLineColor: Colors.black,
                  showBarValue: true,
                  data: [
                    {
                      'id': 'Bar',
                      'data': listChart,
                    }
                  ],
                ),
              );
            }),
      ],
    );
  }
}
