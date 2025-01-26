import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thesis_app/app/themed_scaffold.dart';
import 'package:thesis_app/core/constants/enums.dart';
import 'package:thesis_app/dependencies/injection_container.dart';
import 'package:thesis_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:thesis_app/features/home/presentation/home_page.dart';
import 'package:thesis_app/features/auth/presentation/register_page.dart';
import 'package:thesis_app/features/widgets/custom_button.dart';
import 'package:thesis_app/features/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Unknown error',
                ),
              ),
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
                        Image.asset(
                          height: 148,
                          'assets/logos/university_logo.png',
                          fit: BoxFit.contain,
                        ),
                        const Spacer(),
                        CustomTextField(
                          hintText: 'Enter your email',
                          assetImage: 'assets/icons/mail.svg',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'Password',
                          assetImage: 'assets/icons/lock.svg',
                          controller: passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Forget password?',
                              style: TextStyle(
                                color: Color(0xFF005F8B),
                                fontWeight: FontWeight.w600,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        CustomButton(
                          text: 'Login',
                          onPressed: () {
                            context.read<AuthCubit>().signIn(
                                  emailController.text,
                                  passwordController.text,
                                );
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New Member? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Register now',
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
