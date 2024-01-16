import 'package:flutter/material.dart';

class SchemeDetailsView extends StatelessWidget {
  const SchemeDetailsView({super.key, required this.scheme});
  final Map<String, dynamic> scheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scheme['name']!),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            opacity: const AlwaysStoppedAnimation(0.15),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scheme['name']!, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Text('Eligibilty : ${scheme['eligibilty']!}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  Text(scheme['details']!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
