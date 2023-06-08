import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/constants/routes.dart';
import 'package:flutter_final_project/helpers/barcode_scanner.dart';
import 'package:flutter_final_project/page_navigation/bloc/page_nav_bloc.dart';
import 'package:flutter_final_project/services/auth/auth_service.dart';
import 'package:flutter_final_project/services/cloud/cloud_item.dart';
import 'package:flutter_final_project/services/cloud/firebase_cloud_storage_items.dart';
import 'package:flutter_final_project/utilities/generics/get_arguments.dart';

import '../../helpers/myappbar.dart';

class CreateUpdateItemView extends StatefulWidget {
  const CreateUpdateItemView({Key? key}) : super(key: key);

  @override
  _CreateUpdateItemViewState createState() => _CreateUpdateItemViewState();
}

class _CreateUpdateItemViewState extends State<CreateUpdateItemView> {
  String? scanResult;
  CloudItem? _item;
  late final FirebaseCloudStorageItem _itemService;
  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    _itemService = FirebaseCloudStorageItem();
    _nameController = TextEditingController();
    _barcodeController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final item = _item;
    if (item == null) {
      return;
    }
    final name = _nameController.text;
    final barcode = _barcodeController.text;
    final price = int.parse(_priceController.text);
    final quantity = int.parse(_quantityController.text);
    await _itemService.updateItem(
      documentId: item.documentId,
      name: name,
      barcode: barcode,
      price: price,
      quantity: quantity,
    );
  }

  void _setupTextControllerListener() {
    _nameController.removeListener(_textControllerListener);
    _nameController.addListener(_textControllerListener);
    _barcodeController.removeListener(_textControllerListener);
    _barcodeController.addListener(_textControllerListener);
    _priceController.removeListener(_textControllerListener);
    _priceController.addListener(_textControllerListener);
    _quantityController.removeListener(_textControllerListener);
    _quantityController.addListener(_textControllerListener);
  }

  Future<CloudItem> createOrGetExistingItem(BuildContext context) async {
    final widgetItem = context.getArgument<CloudItem>();

    if (widgetItem != null) {
      _item = widgetItem;
      _nameController.text = widgetItem.name;
      _priceController.text = widgetItem.price.toString();
      _quantityController.text = widgetItem.quantity.toString();
      return widgetItem;
    }

    final existingItem = _item;
    if (existingItem != null) {
      return existingItem;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newItem = await _itemService.createNewItem(
        ownerUserId: userId, name: '', price: 0, quantity: 0);
    _item = newItem;
    return newItem;
  }

  void _deleteItemIfNameIsEmpty() {
    final item = _item;
    if (_nameController.text.isEmpty && item != null) {
      _itemService.deleteItem(documentId: item.documentId);
    }
  }

  void _saveItemIfNameNotEmpty() async {
    final item = _item;
    final name = _nameController.text;
    final barcode = _barcodeController.text;
    final price = int.parse(_priceController.text);
    final quantity = int.parse(_quantityController.text);
    if (item != null && name.isNotEmpty) {
      await _itemService.updateItem(
        documentId: item.documentId,
        name: name,
        price: price,
        quantity: quantity,
        barcode: barcode,
      );
    }
  }

  @override
  void dispose() {
    _deleteItemIfNameIsEmpty();
    _saveItemIfNameNotEmpty();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
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
          Navigator.of(context).pushNamed(itemViewRoute);
        } else if (state is PressedItemViewState) {
          Navigator.of(context).pushNamed(itemViewRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            centerTitle: true,
            title: const Text(
              'Add / Update Items',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _deleteItemIfNameIsEmpty();
                //Navigator.of(context).pop();
                BlocProvider.of<PageNavBloc>(context)
                    .add(PressedBackButtonEvent());
              },
            ),
          ),
          body: FutureBuilder(
            future: createOrGetExistingItem(context),
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
                          controller: _nameController,
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
                          controller: _barcodeController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Item Barcode',
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
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Item Price',
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
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Item quantity',
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
                                  .add(PressedItemViewEvent());
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(appBarColor),
                            ),
                            child: const Text('Add/Update Item!'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(barcodeScanViewRoute);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(appBarColor),
                            ),
                            child: const Text('Scan Barcode'),
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

// class BarcodeScanner extends StatefulWidget {
//   const BarcodeScanner({super.key});

//   @override
//   State<BarcodeScanner> createState() => _BarcodeScannerState();
// }

// class _BarcodeScannerState extends State<BarcodeScanner> {
//   String _scanBarcode = 'unknown';
//   Future<void> startBarcodeScanStream() async {
//     FlutterBarcodeScanner.getBarcodeStreamReceiver(
//             '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
//         .listen((barcode) => print(barcode));
//   }

//   Future<void> barcodeScan() async {
//     String barcodeScanRes;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.QR);
//       print(barcodeScanRes);
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//     if (!mounted) return;
//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//   }
