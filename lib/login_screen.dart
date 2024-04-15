import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/auth_bloc.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/sign_up_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerUserName = TextEditingController();
    final TextEditingController controllerPassword = TextEditingController();
    final TextEditingController controllerResetPassword =
        TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                hintText: 'Login',
                controller: controllerUserName,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controllerPassword,
                hintText: 'Password',
                isObscure: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LoginEvent(
                        email: controllerUserName.text,
                        password: controllerPassword.text));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
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

                      return const Text('Login');
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthResetPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content:
                                Text('Check your email for reset password!'),
                          ),
                        );
                      }
                    },
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.sizeOf(context).height * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Enter your email'),
                                  const SizedBox(height: 50),
                                  CustomTextField(
                                      controller: controllerResetPassword,
                                      hintText: 'Email'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                        ResetPasswordEvent(
                                          email: controllerResetPassword.text,
                                        ),
                                      );

                                  Navigator.of(context).pop();
                                },
                                child: const Text('Reset'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              )
                            ],
                          ),
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                  ),
                  child: const Text('Sign Up'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure = false,
  });
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
