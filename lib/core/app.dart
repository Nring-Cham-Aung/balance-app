import 'package:balance/core/app_lifecycle.dart';
import 'package:balance/feature/home_page.dart';
import 'package:balance/feature/home_repository.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Balance",
      debugShowCheckedModeBanner: false,
      home: HomePage(lifecycle: AppLifecycle(), repo: HomeRepository(),),
    );
  }
}