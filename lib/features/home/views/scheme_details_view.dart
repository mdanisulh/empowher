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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.amberAccent,
        child: SingleChildScrollView(
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
      ),
    );
  }
}
