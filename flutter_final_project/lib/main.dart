import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/helpers/barcode_scanner.dart';
import 'package:flutter_final_project/page_navigation/bloc/page_nav_bloc.dart';
import 'package:flutter_final_project/screens/forgot_password.dart';
import 'package:flutter_final_project/screens/orders/order_view.dart';
import 'package:flutter_final_project/screens/orders/update_order.dart';
import 'package:flutter_final_project/screens/transactions/sales_entry_form.dart';
import 'package:flutter_final_project/screens/login.dart';
import 'package:flutter_final_project/screens/items/create_update_item.dart';
import 'package:flutter_final_project/screens/items/items_view.dart';
import 'package:flutter_final_project/screens/main_page.dart';
import 'package:flutter_final_project/screens/registration.dart';
import 'package:flutter_final_project/screens/transactions/transaction_view.dart';
import 'package:flutter_final_project/screens/verify_email.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_event.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_state.dart';
import 'package:flutter_final_project/services/auth/firebase_auth_provider.dart';
// import 'package:path/path.dart';
import 'constants/routes.dart';
import 'helpers/loading_screen.dart';
import 'services/cloud/bloc/crud_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(FirebaseAuthProvider()),
          ),
          BlocProvider<CloudStorageBloc>(
            create: (context) => CloudStorageBloc(),
          ),
          BlocProvider<PageNavBloc>(
            create: ((context) => PageNavBloc()),
          ),
        ],
        child: const HomePage(),
      ),
      routes: {
        barcodeScanViewRoute: (context) => const BarcodeScanner(),
        createOrUpdateItemRoute: (context) => const CreateUpdateItemView(),
        itemViewRoute: (context) => const ItemView(),
        salesEntryRoute: (context) => const SalesEntry(),
        transactionViewRoute: (context) => const TransactionView(),
        mainPageRoute: (context) => const MainPage(),
        orderViewRoute: (context) => const OrderView(),
        updateOrderRoute: (context) => const UpdateOrderView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MainPage();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
