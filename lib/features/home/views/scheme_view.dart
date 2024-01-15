import 'package:csc_picker/csc_picker.dart';
import 'package:empowher/features/home/widgets/scheme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchemeView extends ConsumerStatefulWidget {
  const SchemeView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchemeViewState();
}

class _SchemeViewState extends ConsumerState<SchemeView> {
  String? state;
  List<Map<String, String>> schemes = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              suffixIcon: Icon(Icons.search),
              hintText: 'Search',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CSCPicker(
            showCities: false,
            defaultCountry: CscCountry.India,
            countryFilter: const [CscCountry.India],
            onCountryChanged: (_) {},
            onStateChanged: (value) {
              setState(() {
                state = value;
              });
            },
            onCityChanged: (_) {},
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return SchemeCard(scheme: schemes[index]);
            },
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
