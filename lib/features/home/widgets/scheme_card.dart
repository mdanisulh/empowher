import 'package:empowher/features/home/views/scheme_details_view.dart';
import 'package:flutter/material.dart';

class SchemeCard extends StatelessWidget {
  const SchemeCard({super.key, required this.scheme});
  final Map<String, dynamic> scheme;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SchemeDetailsView(scheme: scheme)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.amberAccent,
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Colors.yellow.shade100,
          //     Colors.yellowAccent.shade700,
          //   ],
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Wrap(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scheme['name']!, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('Eligibilty : ${scheme['eligibilty']!}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  Text(scheme['details']!, maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
