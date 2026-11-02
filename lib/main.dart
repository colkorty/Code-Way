import 'package:codeway/app_colors.dart';
import 'package:codeway/screens/authentication_screen.dart';
import 'package:codeway/screens/main_screen.dart';
import 'package:codeway/services/auth_service.dart';
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
                scaffoldBackgroundColor: const Color.fromARGB(255, 215, 216, 233),
                textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Color(0x4DFFFFFF),
                    selectionHandleColor: Colors.white,
                ),
                extensions: const [
                    AppColors(
                        mainBackground: Color.fromARGB(255, 215, 216, 233),
                        mainElements: Color.fromARGB(255, 58, 58, 58),
                        fill: Color(0xFFD4D5EA),
                        border: Color(0xFFBEBFD4),
                        buttonText: Color(0xFF575757),
                    ),
                ],
            ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF2C2C3B),
                textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Color(0x4DFFFFFF),
                    selectionHandleColor: Colors.white,
                ),
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
            home: StreamBuilder(
                stream: AuthService().userStateChanges, 
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(
                            body: Center(child: CircularProgressIndicator(),),
                        );
                    }

                    if (snapshot.hasError) {
                        return const Scaffold(
                            body: Center(child: Text('Не удалось проверить авторизацию'),),
                        );
                    }

                    if (snapshot.data != null) {
                        return const MainScreen();
                    }

                    return const AuthenticationScreen(showBackButton: false);
                }
            ),
        );
    }
}
