import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/helpers/myappbar.dart';
import 'package:flutter_final_project/screens/orders/order_list.dart';
import 'package:flutter_final_project/services/cloud/cloud_orders.dart';
import 'package:flutter_final_project/services/cloud/firebase_cloud_storage_orders.dart';
import '../../constants/routes.dart';
import '../../page_navigation/bloc/page_nav_bloc.dart';
import '../../services/auth/auth_service.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  late final FirebaseCloudStorageOrders _orderService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _orderService = FirebaseCloudStorageOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PageNavBloc>(
          create: (BuildContext context) => PageNavBloc(),
        ),
      ],
      child: Scaffold(body: blocBody(context)),
    );
  }

  Widget blocBody(BuildContext buildcontext) {
    return BlocConsumer<PageNavBloc, PageNavState>(
      listener: (context, state) {
        if (state is PressedBackButtonState) {
          Navigator.of(buildcontext).pushNamed(mainPageRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            centerTitle: true,
            title: const Text('Orders'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Navigator.of(context).pushNamed(mainPageRoute);
                BlocProvider.of<PageNavBloc>(context)
                    .add(PressedBackButtonEvent());
              },
            ),
          ),
          body: StreamBuilder(
            stream: _orderService.allOrders(
              ownerUserId: userId,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allOrders = snapshot.data as Iterable<CloudOrder>;
                    return OrderListView(
                      orders: allOrders,
                      onDeleteorder: (order) async {
                        await _orderService.deleteOrder(
                            documentId: order.documentId);
                      },
                      onTap: (order) {
                        Navigator.of(context).pushNamed(
                          updateOrderRoute,
                          arguments: order,
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }
}
