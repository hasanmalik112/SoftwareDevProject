import 'package:flutter/material.dart';
import 'package:flutter_final_project/dashboard/responsive/sales_barchart.dart';
import 'package:flutter_final_project/helpers/my_drawer.dart';
import 'package:flutter_final_project/helpers/myappbar.dart';
import '../utils/my_box.dart';
import '../utils/my_tile.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar,
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "hello world",
              style: TextStyle(fontSize: 20),
            ),
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
            SalesChart()
          ],
        ),
      ),
    );
  }
}

// Scaffold(
//       backgroundColor: defaultBackgroundColor,
//       appBar: myAppBar,
//       drawer: myDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Text(
//               "hello world",
//               style: TextStyle(fontSize: 20),
//             )
//             // first 4 boxes in grid
//             // AspectRatio(
//             //   aspectRatio: 1,
//             //   child: SizedBox(
//             //     width: double.infinity,
//             //     child: GridView.builder(
//             //       itemCount: 4,
//             //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             //           crossAxisCount: 2),
//             //       itemBuilder: (context, index) {
//             //         return MyBox();
//             //       },
//             //     ),
//             //   ),
//             // ),

//             // list of previous days
//             // Expanded(
//             //   child: SalesChart(),
//             // ),
//           ],
//         ),
//       ),
//     );