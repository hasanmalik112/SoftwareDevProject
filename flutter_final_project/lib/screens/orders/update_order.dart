import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/constants/routes.dart';
import 'package:flutter_final_project/page_navigation/bloc/page_nav_bloc.dart';
import 'package:flutter_final_project/services/cloud/cloud_orders.dart';
import 'package:flutter_final_project/services/cloud/firebase_cloud_storage_orders.dart';
import 'package:flutter_final_project/utilities/generics/get_arguments.dart';

import '../../helpers/myappbar.dart';

class UpdateOrderView extends StatefulWidget {
  const UpdateOrderView({super.key});

  @override
  State<UpdateOrderView> createState() => _UpdateOrderViewState();
}

class _UpdateOrderViewState extends State<UpdateOrderView> {
  CloudOrder? _order;
  // bool isOrderFulfilled = false;
  late final FirebaseCloudStorageOrders _orderService;
  late final TextEditingController _docIdController;
  late final TextEditingController _prodnameController;
  late final TextEditingController _orderStatusController;
  late final TextEditingController _orderamountController;
  late final TextEditingController _orderquantityController;

  @override
  void initState() {
    _orderService = FirebaseCloudStorageOrders();
    _docIdController = TextEditingController();
    _prodnameController = TextEditingController();
    _orderStatusController = TextEditingController();
    _orderamountController = TextEditingController();
    _orderquantityController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final docId = _docIdController.text;
    final name = _prodnameController.text;
    final status = _orderStatusController.text;
    final amount = int.parse(_orderamountController.text);
    final quantity = int.parse(_orderquantityController.text);
    await _orderService.updateOrder(
      documentId: docId,
      productName: name,
      orderStatus: status,
      orderAmount: amount,
      orderQuantity: quantity,
    );
  }

  void _setupTextControllerListener() {
    _prodnameController.removeListener(_textControllerListener);
    _prodnameController.addListener(_textControllerListener);
    _orderStatusController.removeListener(_textControllerListener);
    _orderStatusController.addListener(_textControllerListener);
    _docIdController.removeListener(_textControllerListener);
    _docIdController.addListener(_textControllerListener);
    _orderquantityController.removeListener(_textControllerListener);
    _orderquantityController.addListener(_textControllerListener);
    _orderamountController.removeListener(_textControllerListener);
    _orderamountController.addListener(_textControllerListener);
  }

  Future<CloudOrder?> getExistingOrder(BuildContext context) async {
    final widgetOrder = context.getArgument<CloudOrder>();

    if (widgetOrder != null) {
      _order = widgetOrder;
      _docIdController.text = widgetOrder.documentId;
      _prodnameController.text = widgetOrder.productname;
      _orderamountController.text = widgetOrder.orderAmount.toString();
      _orderquantityController.text = widgetOrder.orderQuantity.toString();
      _orderStatusController.text = widgetOrder.orderStatus;
      return widgetOrder;
    }

    final existingOrder = _order;
    if (existingOrder != null) {
      return existingOrder;
    }

    return null;
  }

  void _deleteOrderIfIdIsEmpty() {
    final order = _order;
    if (_docIdController.text.isEmpty && order != null) {
      _orderService.deleteOrder(documentId: order.documentId);
    }
  }

  @override
  void dispose() {
    _deleteOrderIfIdIsEmpty();
    _docIdController.dispose();
    _prodnameController.dispose();
    _orderamountController.dispose();
    _orderquantityController.dispose();
    _orderStatusController.dispose();
    super.dispose();
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
          //_deleteItemIfNameIsEmpty();
          Navigator.of(context).pop();
        } else if (state is PressedOrderViewState) {
          Navigator.of(context).pushNamed(orderViewRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            centerTitle: true,
            title: const Text(
              'Update Order',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _deleteOrderIfIdIsEmpty();
                //Navigator.of(context).pop();
                BlocProvider.of<PageNavBloc>(context)
                    .add(PressedBackButtonEvent());
              },
            ),
          ),
          body: FutureBuilder(
            future: getExistingOrder(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _prodnameController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Item Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _orderamountController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Order Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _orderquantityController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'order quantity',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _docIdController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Order Id',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _orderStatusController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Order Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              //Navigator.of(context).pushNamed(itemViewRoute);
                              BlocProvider.of<PageNavBloc>(context)
                                  .add(PressedOrderViewEvent());
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(appBarColor),
                            ),
                            child: const Text('Update Order!'),
                          ),
                        ],
                      ),
                    ],
                  );
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
