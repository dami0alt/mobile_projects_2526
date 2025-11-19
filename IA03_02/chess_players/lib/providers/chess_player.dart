import 'package:flutter/material.dart';
import '../entities/player.dart';
import '../utils/chess_api.dart';
// Importa la clase de datos personalizados que debe estar en el mismo directorio o models
// import '../models/custom_player_data.dart';

class PlayerStore extends ChangeNotifier {
  List<Player> players = [];
  Map<String, CustomPlayerData> customizations = {};

  // 🎯 Lista de usuarios fijos que queremos buscar
  static const List<String> targetUsernames = [
    'Darco8987',
    'MagnusCarlsen',
    'Hikaru',
    'Carnicerooii',
    'LyonBeast',
    // Puedes añadir más aquí
  ];

  Future<void> loadPlayers() async {
    // ⬇️ Llama a la nueva función de ApiService pasándole la lista fija
    players = await ApiService.fetchPlayersByUsername(targetUsernames);
    notifyListeners();
  }

  CustomPlayerData getCustomization(String username) =>
      customizations[username] ?? CustomPlayerData();

  void updateCustomization(String username, CustomPlayerData data) {
    customizations[username] = data;
    notifyListeners();
  }
}
