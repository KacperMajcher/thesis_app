import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_app/app/themed_scaffold.dart';
import 'package:thesis_app/core/constants/enums.dart';
import 'package:thesis_app/dependencies/injection_container.dart';
import 'package:thesis_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:thesis_app/features/auth/presentation/login_page.dart';
import 'package:thesis_app/features/home/presentation/home_page.dart';
import 'package:thesis_app/features/widgets/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
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
              SnackBar(content: Text(state.errorMessage ?? 'Unknown error')),
            );
          }
        },
        builder: (context, state) {
          return ThemedScaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    SizedBox(height: 70),
                    Image.asset(
                      height: 148,
                      'assets/logos/university_logo.png',
                      fit: BoxFit.contain,
                    ),
                    Spacer(),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hintText: 'Full name',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      assetImage: 'assets/icons/user.svg',
                    ),
                    CustomTextField(
                      hintText: 'Valid email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      assetImage: 'assets/icons/mail.svg',
                    ),
                    CustomTextField(
                      hintText: 'Strong password',
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      assetImage: 'assets/icons/lock.svg',
                      obscureText: true,
                    ),
                    CustomTextField(
                      hintText: 'Confirm password',
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      assetImage: 'assets/icons/lock.svg',
                      obscureText: true,
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text ==
                            confirmPasswordController.text) {
                          context.read<AuthCubit>().signUp(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match'),
                            ),
                          );
                        }
                      },
                      child: const Text('Register'),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text('Or login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
