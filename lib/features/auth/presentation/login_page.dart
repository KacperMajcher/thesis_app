import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_app/app/themed_scaffold.dart';
import 'package:thesis_app/core/constants/enums.dart';
import 'package:thesis_app/dependencies/injection_container.dart';
import 'package:thesis_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:thesis_app/features/home/presentation/home_page.dart';
import 'package:thesis_app/features/auth/presentation/register_page.dart';
import 'package:thesis_app/features/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state.status == LoginStatus.success) {
          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(user: user),
              ),
            );
          }
        }
        if (state.status == LoginStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Unknown error',
              ),
            ),
          );
        }
      }, builder: (context, state) {
        return ThemedScaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70),
                  Image.asset(
                    height: 148,
                    'assets/logos/university_logo.png',
                    fit: BoxFit.contain,
                  ),
                  Spacer(),
                  CustomTextField(
                    hintText: 'Enter your email',
                    assetImage: 'assets/icons/mail.svg',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Password',
                    assetImage: 'assets/icons/lock.svg',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            context.read<AuthCubit>().signIn(
                                  emailController.text,
                                  passwordController.text,
                                );
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Log In'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: const Text('Or register'),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
