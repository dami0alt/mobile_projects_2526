import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController firstNameC = TextEditingController();
  TextEditingController lastNameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  RxnString photoUrl = RxnString();
  SupabaseClient client = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> logout() async {
    await client.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> user = await client
          .from("listeners")
          .select()
          .eq("email", client.auth.currentUser!.email ?? "")
          .single();

      firstNameC.text = user["fname"] ?? "";
      lastNameC.text = user["lname"] ?? "";
      emailC.text = user["email"] ?? "";

      // 👇 NUEVO: Guardamos la URL de la foto
      photoUrl.value = user["photo_url"];
    } catch (e) {
      Get.snackbar("Error", "No se pudo cargar el perfil: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (firstNameC.text.isNotEmpty && lastNameC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await client.from("listeners").update({
          "fname": firstNameC.text,
          "lname": lastNameC.text,
        }).eq("email", client.auth.currentUser!.email ?? "");

        if (passwordC.text.isNotEmpty) {
          if (passwordC.text.length >= 6) {
            await client.auth.updateUser(UserAttributes(
              password: passwordC.text,
            ));
          } else {
            Get.snackbar(
                "ERROR", "La contraseña debe tener al menos 6 caracteres");
            isLoading.value = false;
            return;
          }
        }

        Get.defaultDialog(
            barrierDismissible: false,
            title: "Perfil Actualizado",
            middleText: "Tus datos se han guardado correctamente.",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("OK"))
            ]);
      } catch (e) {
        Get.snackbar("ERROR", "Falló la actualización: $e");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Atención", "Nombre y Apellido son obligatorios");
    }
  }
}
