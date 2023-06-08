// import 'package:flutter/material.dart';
// import 'package:flutter_final_project/services/auth/bloc/auth_bloc.dart';
// import 'package:flutter_final_project/services/auth/bloc/auth_event.dart';
// import 'package:flutter_final_project/services/auth/bloc/auth_state.dart';
// import 'package:golden_toolkit/golden_toolkit.dart';
// import 'package:flutter_final_project/screens/login.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

//   class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// void main() {
//   group('LoginView', () {
//     late MockAuthBloc authBloc;

//     setUp(() {
//       authBloc = MockAuthBloc();
//     });

//     testWidgets('renders login view correctly', (tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<AuthBloc>.value(
//             value: authBloc,
//             child: const LoginView(),
//           ),
//         ),
//       );

//       testGoldens('DeviceBuilder - multiple scenarios - with onCreate',
//       (tester) async {
//     final builder = DeviceBuilder()
//       ..overrideDevicesForAllScenarios(devices: [
//         Device.phone,
//         Device.iphone11,
//         Device.tabletPortrait,
//         Device.tabletLandscape,
//       ])
//       ..addScenario(
//         widget: const LoginView(),
//         name: 'sc page',
//       );

//     await tester.pumpDeviceBuilder(
//       builder,
//       wrapper: materialAppWrapper(
//         theme: ThemeData.light(),
//         platform: TargetPlatform.android,
//       ),
//     );

//     await screenMatchesGolden(tester, 'LoginScreen');
//   });
//     });
//   });
// }

//   // testGoldens('DeviceBuilder - multiple scenarios - with onCreate',
//   //     (tester) async {
//   //   final builder = DeviceBuilder()
//   //     ..overrideDevicesForAllScenarios(devices: [
//   //       Device.phone,
//   //       Device.iphone11,
//   //       Device.tabletPortrait,
//   //       Device.tabletLandscape,
//   //     ])
//   //     ..addScenario(
//   //       widget: const LoginView(),
//   //       name: 'sc page',
//   //     );

//   //   await tester.pumpDeviceBuilder(
//   //     builder,
//   //     wrapper: materialAppWrapper(
//   //       theme: ThemeData.light(),
//   //       platform: TargetPlatform.android,
//   //     ),
//   //   );

//   //   await screenMatchesGolden(tester, 'LoginScreen');
//   // });

