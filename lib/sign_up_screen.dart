import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/auth_bloc.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerUserName = TextEditingController();
    final TextEditingController controllerPassword = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        centerTitle: true,
        title: const Text(
          'Sign Up ',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: controllerUserName,
                hintText: 'Email',
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controllerPassword,
                hintText: 'Password',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      SignUpEvent(
                          email: controllerUserName.text,
                          password: controllerPassword.text),
                    );
                  },
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.close),
                              )
                            ],
                            content: Text(state.errorText),
                          ),
                        );
                      }
                      if (state is AuthSuccess) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      log(state.toString());
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }

                      return const Text('Sign up');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
