import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_app/app/themed_scaffold.dart';
import 'package:thesis_app/core/constants/enums.dart';
import 'package:thesis_app/dependencies/injection_container.dart';
import 'package:thesis_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:thesis_app/features/auth/presentation/login_page.dart';
import 'package:thesis_app/features/home/presentation/home_page.dart';
import 'package:thesis_app/features/widgets/custom_button.dart';
import 'package:thesis_app/features/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isChecked = false;

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
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),

                        /// Logo
                        Image.asset(
                          height: 148,
                          'assets/logos/university_logo.png',
                          fit: BoxFit.contain,
                        ),

                        /// Spacer before form fields
                        const Spacer(),

                        /// Name field
                        CustomTextField(
                          hintText: 'Full name',
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          assetImage: 'assets/icons/user.svg',
                        ),
                        const SizedBox(height: 10),

                        /// Email field
                        CustomTextField(
                          hintText: 'Valid email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          assetImage: 'assets/icons/mail.svg',
                        ),
                        const SizedBox(height: 10),

                        /// Password field
                        CustomTextField(
                          hintText: 'Strong password',
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          assetImage: 'assets/icons/lock.svg',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),

                        /// Confirm Password field
                        CustomTextField(
                          hintText: 'Confirm password',
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          assetImage: 'assets/icons/lock.svg',
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),

                        /// Checkbox for Terms and Conditions
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFF005F8B),
                                checkColor: Colors.white,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    const TextSpan(
                                        text:
                                            'By checking the box you agree to our '),
                                    TextSpan(
                                      text: 'Terms',
                                      style: const TextStyle(
                                        color: Color(0xFF005F8B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Conditions',
                                      style: const TextStyle(
                                        color: Color(0xFF005F8B),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                      ),
                                    ),
                                    const TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        /// Spacer before Register button
                        const Spacer(),

                        /// Register button
                        CustomButton(
                          text: 'Register',
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
                        ),
                        const SizedBox(height: 15),

                        /// Already a member - Navigate to LoginPage
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already member? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                  color: Color(0xFF005F8B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
