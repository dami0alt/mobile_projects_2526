import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movies/screens/main.dart';

// Entry point of the application. We run the root widget: MyApp
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Constant constructor. Passes the optional key to the parent class.
  const MyApp({super.key});
  // Override the build method from StatelessWidget.
  // It receives the BuildContext and returns the widget tree.
  @override
  Widget build(BuildContext context) {
    // Set the default system status bar color.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF242A32),
      ),
    );
    // Use GetX's GetMaterialApp as the root widget of the application.
    return GetMaterialApp(
      // Remove the debug banner.
      debugShowCheckedModeBanner: false,
      // Global theme configuration: colors and text styles.
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF242A32),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      // Initial screen of the application.
      home: Main(),
    );
  }
}
