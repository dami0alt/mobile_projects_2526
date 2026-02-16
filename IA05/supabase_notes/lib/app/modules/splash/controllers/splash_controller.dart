import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  void onReady() {
    super.onReady();
    // Ejecutamos la validación cuando la vista ya se renderizó
    _validateSession();
  }

  Future<void> _validateSession() async {
    // 1. Efecto visual (Opcional): Esperamos 2 segundos para que vean tu logo
    await Future.delayed(const Duration(seconds: 2));

    // 2. Verificamos la sesión
    final session = _client.auth.currentSession;

    // 3. Semáforo
    if (session != null && !session.isExpired) {
      // Si hay sesión válida -> Home
      Get.offAllNamed(Routes.HOME);
    } else {
      // Si no hay sesión o expiró -> Login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
