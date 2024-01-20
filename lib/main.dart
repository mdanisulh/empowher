import 'package:empowher/.env.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/views/login_view.dart';
import 'package:empowher/features/home/views/home_view.dart';
import 'package:empowher/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: geminiAPIKey);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmpowHer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ref.watch(currentUserProvider).when(
            data: (user) => user == null ? const LoginView() : const HomeView(),
            loading: () => const Loader(),
            error: (e, _) => ErrorPage(error: e.toString()),
          ),
    );
  }
}
