import 'package:flutter/material.dart';

class AppTheme {
  // 1. Paleta de Colores "Spotify"
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color spotifyBlack = Color(0xFF121212); // Fondo principal
  static const Color spotifyDarkGrey = Color(0xFF212121); // Tarjetas / Barras
  static const Color spotifyLightGrey = Color(0xFF535353); // Textos secundarios
  static const Color spotifyWhite = Color(0xFFFFFFFF);

  // 2. Definición del Tema Global
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark, // Importante: Modo Oscuro base
    primaryColor: spotifyGreen,
    scaffoldBackgroundColor: spotifyBlack, // Fondo de toda la app

    // Esquema de colores para componentes
    colorScheme: const ColorScheme.dark(
      primary: spotifyGreen,
      secondary: spotifyWhite,
      surface: spotifyDarkGrey,
      background: spotifyBlack,
      error: Color(0xFFCF6679),
    ),

    // 3. Tipografía Global (Blanca por defecto en modo oscuro)
    fontFamily: 'Montserrat', // O la fuente que prefieras
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, color: spotifyWhite),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: spotifyWhite),
      bodyLarge: TextStyle(fontSize: 16, color: spotifyWhite),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),

    // 4. Estilo de los Inputs (Login/Register/Perfil)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: spotifyDarkGrey, // Fondo gris oscuro
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(30), // Bordes muy redondeados (Pill shape)
        borderSide: BorderSide.none, // Sin borde visible
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
            color: spotifyGreen, width: 2), // Borde verde al tocar
      ),
    ),

    // 5. Estilo de Botones (ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: spotifyGreen, // Fondo Verde
        foregroundColor: Colors.black, // Texto Negro (para contraste)
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Botón pastilla
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    ),

    // 6. AppBar Global
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // Transparente como Spotify
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: spotifyWhite),
      iconTheme: IconThemeData(color: spotifyWhite),
    ),
  );
}
