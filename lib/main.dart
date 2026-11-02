import 'package:codeway/app_colors.dart';
import 'package:codeway/screens/main_screen.dart';
import 'package:codeway/services/firestore_seed_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    await seedFirestoreData();

    runApp(const CodeWay());
}

class CodeWay extends StatelessWidget {
    const CodeWay({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFEBECFF),
                extensions: const [
                    AppColors(
                        mainBackground: Color(0xFFEBECFF),
                        mainElements: Color(0xFF000000),
                        fill: Color(0xFFD4D5EA),
                        border: Color(0xFFBEBFD4),
                        buttonText: Color(0xFF575757),
                    ),
                ],
            ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF2C2C3B),
                extensions: const [
                    AppColors(
                        mainBackground: Color(0xFF2C2C3B),
                        mainElements: Color(0xFFFFFFFF),
                        fill: Color(0xFF23232D),
                        border: Color(0xFF3E3E50),
                        buttonText: Color(0xFFFFFFFF),
                    ),
                ],
            ),
            home: const MainScreen(),
        );
    }
}
