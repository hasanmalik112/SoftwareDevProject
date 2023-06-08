import 'package:flutter/material.dart';
import 'package:flutter_final_project/constants/routes.dart';
import 'package:flutter_final_project/enums/menu_action.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/page_navigation/bloc/page_nav_bloc.dart';
import '../services/auth/bloc/auth_bloc.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_event.dart';
import '../utilities/dialogs/logout_dialog.dart';

var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);
var drawerTextColor = const TextStyle(
  color: Colors.white,
);

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageNavBloc>(
          create: (BuildContext context) => PageNavBloc(),
        ),
      ],
      child: blocBody(context),
    );
  }

  Widget blocBody(BuildContext buildcontext) {
    return BlocConsumer<PageNavBloc, PageNavState>(
      listener: (context, state) {
        if (state is PressedItemViewState) {
          Navigator.of(context).pushNamed(itemViewRoute);
        } else if (state is PressedTransactionViewState) {
          Navigator.of(context).pushNamed(transactionViewRoute);
        } else if (state is PressedAddProductViewState) {
          Navigator.of(context).pushNamed(createOrUpdateItemRoute);
        } else if (state is PressedAddTransactionViewState) {
          Navigator.of(context).pushNamed(salesEntryRoute);
        } else if (state is PressedOrderViewState) {
          Navigator.of(context).pushNamed(orderViewRoute);
        }
      },
      builder: (context, state) {
        return Drawer(
          backgroundColor: const Color.fromARGB(255, 4, 150, 160),
          elevation: 0,
          child: Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: const Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                  title: Text(
                    'V I E W  I T E M',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    // Navigator.of(context).pushNamed(itemViewRoute);
                    print("hi");
                    BlocProvider.of<PageNavBloc>(context)
                        .add(PressedItemViewEvent());
                  },
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  title: Text(
                    'A D D  P R O D U C T',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    // Navigator.of(context).pushNamed(createOrUpdateItemRoute);
                    BlocProvider.of<PageNavBloc>(context)
                        .add(PressedAddProdEvent());
                  },
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: const Icon(
                    Icons.gradient_sharp,
                    color: Colors.white,
                  ),
                  title: Text(
                    'M A K E  T R A N S A C T I O N',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(salesEntryRoute);
                  },
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: const Icon(
                    Icons.update,
                    color: Colors.white,
                  ),
                  title: Text(
                    'T R A N S A C T I O N   H I S T O R Y',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(transactionViewRoute);
                  },
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  title: Text(
                    'V I E W  O R D E R',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    // Navigator.of(context).pushNamed(createOrUpdateItemRoute);
                    BlocProvider.of<PageNavBloc>(context)
                        .add(PressedOrderViewEvent());
                  },
                ),
              ),
              // Padding(
              //   padding: tilePadding,
              //   child: ListTile(
              //     trailing: PopupMenuButton<MenuAction>(
              //       onSelected: (value) async {
              //         switch (value) {
              //           case MenuAction.logout:
              //             final shouldLogout = await showLogOutDialog(context);
              //             if (shouldLogout) {
              //               context.read<AuthBloc>().add(
              //                     const AuthEventLogOut(),
              //                   );
              //             }
              //         }
              //       },
              //       itemBuilder: (context) {
              //         return [
              //           const PopupMenuItem<MenuAction>(
              //             value: MenuAction.logout,
              //             child: Text('Logout'),
              //           ),
              //         ];
              //       },
              //     ),
              //     leading: const Icon(
              //       Icons.logout,
              //       color: Colors.white,
              //     ),
              //     title: Text(
              //       'L O G O U T',
              //       style: drawerTextColor,
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
