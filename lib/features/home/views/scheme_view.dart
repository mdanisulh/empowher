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
  late final TextEditingController searchController;
  List<Map<String, dynamic>> schemes = [];
  String? state;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    getSchemes().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getSchemes() async {
    schemes = await ref.read(schemeAPIProvider).getSchemes(state);
  }

  void search() {
    final String query = searchController.text;
    getSchemes();
    if (query.isNotEmpty) {
      schemes = schemes.where((element) => element['name'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    }
    setState(() {});
    getSchemes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent.withOpacity(0.5),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.topRight,
      //     end: Alignment.bottomLeft,
      //     colors: [
      //       Colors.deepPurpleAccent.withOpacity(0.2),
      //       Colors.deepPurpleAccent,
      //     ],
      //   ),
      // ),
      child: Stack(children: [
        Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          opacity: const AlwaysStoppedAnimation(0.7),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: InkWell(onTap: search, child: const Icon(Icons.search)),
                  hintText: 'Search',
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
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
                  state = value;
                  getSchemes().then((_) => setState(() {}));
                },
                onCityChanged: (_) {},
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => SchemeCard(scheme: schemes[index]),
                itemCount: schemes.length,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
