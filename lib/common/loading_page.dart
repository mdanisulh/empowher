import 'package:empowher/theme/theme.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue.shade100,
            Colors.deepPurpleAccent.shade400,
          ],
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(color: Pallete.white),
            ),
          ),
          Center(
            child: CircleAvatar(
              radius: 60,
              child: Image.asset('assets/images/logo.png'),
            ),
          )
        ],
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Loader(),
      backgroundColor: Colors.white,
    );
  }
}
