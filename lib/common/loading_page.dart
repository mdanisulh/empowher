import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          const Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
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
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue.shade100,
            Colors.deepPurpleAccent.shade400,
          ],
        ),
      ),
      child: const Loader(),
    );
  }
}
