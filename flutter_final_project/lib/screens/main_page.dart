import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/helpers/my_drawer.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_event.dart';
import 'package:flutter_final_project/utilities/dialogs/logout_dialog.dart';

import '../enums/menu_action.dart';
import '../helpers/myappbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // darkTheme:
    // ThemeData.dark();
    // themeMode:
    // _themeMode;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        // iconTheme: const IconThemeData(color: Colors.white),
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text(
            'Welcome To StockEaze',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('logout'),
                  ),
                ];
              },
            )
          ],
        ),
        drawer: const MyDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 250,
                ),
                child: Image.asset('assets/StockEaze.png'),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                  'Welcome to StockEaze - your ultimate inventory management solution!'),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "StockEaze is a powerful and user-friendly app designed to simplify and streamline your inventory management processes. Whether you're a small business owner, a warehouse manager, or an e-commerce entrepreneur, StockEaze is here to help you stay organized, save time, and maximize efficiency."),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "With StockEaze, you can effortlessly keep track of your inventory, monitor stock levels, and ensure accurate stock counts at all times. Our intuitive interface allows you to easily add, edit, and categorize your products, so you always have a clear overview of your available stock"),
              ),
            ],
          ),
        ));
  }
}
