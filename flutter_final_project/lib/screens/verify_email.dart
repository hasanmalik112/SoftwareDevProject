import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_final_project/helpers/background_colors.dart';
import 'package:flutter_final_project/helpers/my_button.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_final_project/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // appBar: AppBar(
      //   // var defaultBackgroundColor = Colors.grey[300];
      //   backgroundColor: Colors.grey[900],
      //   title: const Text(
      //     'Email Verification',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   centerTitle: true,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: screenColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Please verify your email.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Text(
                    'If verification email is not recieved press the button below',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    onTap: () {
                      context.read<AuthBloc>().add(
                            const AuthEventSendEmailVerification(),
                          );
                    },
                    title: 'Send verification email',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                      onTap: () async {
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                      },
                      title: 'Back to Sign In')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
