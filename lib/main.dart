import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_firebase/controller/auth_controller.dart';
import 'package:notes_app_with_firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Notes App',
    home: Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
}