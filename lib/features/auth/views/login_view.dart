import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/auth/views/sign_up_view.dart';
import 'package:empowher/features/auth/widgets/auth_field.dart';
import 'package:empowher/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginWithGoogle() {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context: context);
  }

  void loginWithEmail() {
    ref.read(authControllerProvider.notifier).loginWithEmail(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthField(
                  textEditingController: emailController,
                  label: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25),
                AuthField(
                  textEditingController: passwordController,
                  label: 'Password',
                  obscureText: true,
                  textInputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundedSmallButton(
                    onTap: loginWithEmail,
                    label: 'Login',
                  ),
                ),
                const SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(fontSize: 16, color: Pallete.grey),
                    children: [
                      TextSpan(
                        text: ' Sign up',
                        style: const TextStyle(
                          color: Pallete.blue,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpView(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RoundedSmallButton(
                  onTap: loginWithGoogle,
                  label: 'Login with Google',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
