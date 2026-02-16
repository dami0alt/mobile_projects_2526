import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  // await dotenv.load();
  // String supaUri = dotenv.get('SUPABASE_URL'); //get env key
  // String supaAnon = dotenv.get('SUPABASE_ANONKEY');
  await Supabase.initialize(
    url: "https://tspwyazpitxotvcsolyb.supabase.co",
    anonKey: "sb_publishable_8DyZcTpyI2sWbnn4kr_KfQ_U-UWcwMY",
  );
  runApp(App());
}
