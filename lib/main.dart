import 'package:assets/binding.dart';
import 'package:assets/pages/assets/assets_page.dart';
import 'package:assets/pages/menu/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await initBinding();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Assets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuPage(),
        '/assets': (context) => const AssetsPage(),
      },
    );
  }
}
