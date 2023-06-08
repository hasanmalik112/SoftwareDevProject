import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/items/items_view.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_final_project/screens/login.dart';

void main() async {
  testGoldens('DeviceBuilder - multiple scenarios - with onCreate',
      (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ])
      ..addScenario(
        widget: const ItemView(),
        name: 'sc page',
      );

    await tester.pumpDeviceBuilder(
      builder,
      wrapper: materialAppWrapper(
        theme: ThemeData.light(),
        platform: TargetPlatform.android,
      ),
    );

    await screenMatchesGolden(tester, 'ItemView');
  });
}
