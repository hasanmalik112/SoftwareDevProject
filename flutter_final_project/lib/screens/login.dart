import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/helpers/background_colors.dart';
import 'package:flutter_final_project/helpers/my_button.dart';
import 'package:flutter_final_project/services/auth/auth_exception.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_event.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_state.dart';
import 'package:flutter_final_project/utilities/dialogs/error_dialog.dart';
// import 'package:flutter_final_project/assets/google_logo.png';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'cannot find user with  the entered credentials',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              'incorrect password',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Auth error',
            );
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: screenColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Icon(
                      Icons.lock,
                      size: 100,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Welcome back you\'ve been missed!',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      maxLength: 20,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.password),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthEventForgotPassword(),
                                  );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                      onTap: () async {
                        final email = _email.text;
                        final password = _password.text;
                        context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                email,
                                password,
                              ),
                            );
                      },
                      title: 'Sign In',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          )),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Or continue with'),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          )),
                        ],
                      ),
                    ),
                    MyButton(
                        onTap: () {
                          context.read<AuthBloc>().add(
                                const AuthEventGoogleSignIn(),
                              );
                        },
                        title: 'Sign In With Google'),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                        onTap: () {
                          context.read<AuthBloc>().add(
                                const AuthEventFaceBookSignIn(),
                              );
                        },
                        title: "Sign In With Facebook"),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not a member?'),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventShouldRegister(),
                                );
                          },
                          child: const Text(
                            'Register Now!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
