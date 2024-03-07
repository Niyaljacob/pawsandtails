import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/db/model/data_model.dart';
import 'package:paws_and_tail/firebase_options.dart';
import 'package:paws_and_tail/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Hive.initFlutter();
      Hive.registerAdapter(EventDetailsModelAdapter()); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColo.primaryColor1,
      ),
      home: const SplashScreen(),
    );
  }
}
