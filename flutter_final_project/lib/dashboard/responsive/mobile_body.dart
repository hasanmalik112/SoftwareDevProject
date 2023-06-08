import 'package:flutter/material.dart';
import 'package:flutter_final_project/helpers/my_drawer.dart';
import 'package:flutter_final_project/helpers/myappbar.dart';
// import 'package:fl_chart/fl_chart.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: const MyDrawer(),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "hello world",
              style: TextStyle(fontSize: 20),
            )
            // first 4 boxes in grid
            // AspectRatio(
            //   aspectRatio: 1,
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: GridView.builder(
            //       itemCount: 4,
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2),
            //       itemBuilder: (context, index) {
            //         return MyBox();
            //       },
            //     ),
            //   ),
            // ),

            // list of previous days
            // Expanded(
            //   child: SalesChart(),
            // ),
          ],
        ),
      ),
    );
  }
}
