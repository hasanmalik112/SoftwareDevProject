import 'package:flutter/material.dart';
import 'package:flutter_final_project/dashboard/responsive/desktop_body.dart';
import 'package:flutter_final_project/dashboard/responsive/mobile_body.dart';
import 'package:flutter_final_project/dashboard/responsive/tablet_body.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return const MobileScaffold();
        } else if (constraints.maxWidth < 1100) {
          return const TabletScaffold();
        } else {
          return const DesktopScaffold();
        }
      },
    );
  }
}
