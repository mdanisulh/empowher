import 'package:csc_picker/csc_picker.dart';
import 'package:empowher/apis/scheme_api.dart';
import 'package:empowher/features/home/widgets/scheme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchemeView extends ConsumerStatefulWidget {
  const SchemeView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchemeViewState();
}

class _SchemeViewState extends ConsumerState<SchemeView> {
  List<Map<String, dynamic>> schemes = [];
  void getSchemes(String? state) async {
    schemes = await ref.read(schemeAPIProvider).getSchemes(state);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSchemes(null);
  }

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
              getSchemes(value);
            },
            onCityChanged: (_) {},
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return SchemeCard(scheme: schemes[index]);
            },
            itemCount: schemes.length,
          ),
        ),
      ],
    );
  }
}
