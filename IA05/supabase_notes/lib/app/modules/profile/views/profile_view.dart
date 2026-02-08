// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_notes/app/controllers/auth_controller.dart';
import 'package:supabase_notes/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              // Lógica de Logout limpia
              await controller.logout();
              await authC.resetTimer(); // Si usas timer en Auth
            },
            child: const Text(
              "LOGOUT",
              style: TextStyle(color: Colors.redAccent), // Color de alerta
            ),
          )
        ],
      ),
      // REEMPLAZO 1: Usamos Obx en lugar de FutureBuilder
      // El controlador ya carga los datos en onInit
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),

            // 👇 CAMBIO PRINCIPAL: Lógica de la Foto
            Center(
              child: CircleAvatar(
                radius: 50, // Un poco más grande para que luzca
                backgroundColor: Colors.grey[200],
                // Si hay URL, usamos NetworkImage. Si no, es null (y se ve el child)
                backgroundImage: (controller.photoUrl.value != null &&
                        controller.photoUrl.value!.isNotEmpty)
                    ? NetworkImage(controller.photoUrl.value!)
                    : null,
                // Si NO hay URL, mostramos el icono
                child: (controller.photoUrl.value == null ||
                        controller.photoUrl.value!.isEmpty)
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 10),

            // Email (Solo lectura)
            Center(
              child: Text(
                controller.emailC.text,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),

            // CAMPO 1: NOMBRE (firstName)
            TextField(
              autocorrect: false,
              controller:
                  controller.firstNameC, // Conectado al controlador nuevo
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Nombre",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // CAMPO 2: APELLIDO (lastName) - ¡NUEVO!
            TextField(
              autocorrect: false,
              controller:
                  controller.lastNameC, // Conectado al controlador nuevo
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Apellido",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // CAMPO 3: PASSWORD
            TextField(
              autocorrect: false,
              controller: controller.passwordC,
              textInputAction: TextInputAction.done,
              obscureText: true, // Ocultar contraseña
              decoration: const InputDecoration(
                labelText: "Nueva contraseña (Opcional)",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                helperText: "Déjalo vacío si no quieres cambiarla",
              ),
            ),
            const SizedBox(height: 40),

            // BOTÓN DE ACCIÓN
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Eliminamos la lógica vieja de comparación (nameC == nameC2)
                  // Simplemente llamamos a updateProfile() que ya valida internamente
                  if (controller.isLoading.isFalse) {
                    await controller.updateProfile();
                    // Nota: El controlador maneja el logout si se cambió la contraseña
                  }
                },
                child: const Text("ACTUALIZAR PERFIL"),
              ),
            ),
          ],
        );
      }),
    );
  }
}
