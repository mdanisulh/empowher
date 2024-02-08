import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/auth/views/login_view.dart';
import 'package:empowher/features/auth/widgets/auth_field.dart';
import 'package:empowher/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUpWithEmail() {
    ref.read(authControllerProvider.notifier).signUpWithEmail(
          context: context,
          email: emailController.text,
          password: passwordController.text,
        );
  }

  void signUpWithGoogle() {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade200.withOpacity(0.5),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            opacity: const AlwaysStoppedAnimation(0.25),
          ),
          Center(
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
                        onTap: signUpWithEmail,
                        label: 'Create',
                      ),
                    ),
                    const SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                        text: "Already have an account?",
                        style: const TextStyle(fontSize: 16, color: Pallete.grey),
                        children: [
                          TextSpan(
                            text: ' Login',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginView(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    RoundedSmallButton(
                      onTap: signUpWithGoogle,
                      label: 'Sign Up with Google',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
