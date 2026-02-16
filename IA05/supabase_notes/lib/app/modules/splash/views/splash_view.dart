import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tu Logo (puedes usar una imagen o un icono grande)
            const Icon(Icons.music_note_rounded,
                size: 100, color: Color.fromARGB(255, 52, 138, 30)),
            const SizedBox(height: 20),
            const Text(
              "MUSIC HUB",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 40),
            // Un indicador de carga discreto
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
