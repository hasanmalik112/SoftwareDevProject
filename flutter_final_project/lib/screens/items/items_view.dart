import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/helpers/myappbar.dart';
import 'package:flutter_final_project/screens/main_page.dart';
// import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import '../../constants/routes.dart';
import '../../page_navigation/bloc/page_nav_bloc.dart';
import '../../services/auth/auth_service.dart';
import '../../services/cloud/cloud_item.dart';
import '../../services/cloud/firebase_cloud_storage_items.dart';
import 'items_list.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class ItemView extends StatefulWidget {
  const ItemView({Key? key}) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  late final FirebaseCloudStorageItem _itemService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _itemService = FirebaseCloudStorageItem();
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
              title: const Text('All Items'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigator.of(context).pushNamed(mainPageRoute);
                  BlocProvider.of<PageNavBloc>(context)
                      .add(PressedBackButtonEvent());
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(createOrUpdateItemRoute);
                  },
                  icon: const Icon(Icons.add),
                ),
              ]),
          body: StreamBuilder(
            stream: _itemService.allItems(
              ownerUserId: userId,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allItems = snapshot.data as Iterable<CloudItem>;
                    return ItemsListView(
                      items: allItems,
                      onDeleteitem: (item) async {
                        await _itemService.deleteItem(
                            documentId: item.documentId);
                      },
                      onTap: (item) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateItemRoute,
                          arguments: item,
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
