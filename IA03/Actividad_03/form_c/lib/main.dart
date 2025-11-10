import 'package:flutter/material.dart';
import 'package:form_c/pages/home_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Salesians Sarrià 25/26 - Form (B)',
          initialRoute: HomePage.routename,
          routes: {HomePage.routename: (context) => const HomePage()},
        );
      },
    );
  }
}
