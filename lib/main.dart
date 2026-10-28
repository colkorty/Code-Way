import 'package:codeway/screens/map_screen.dart';
import 'package:codeway/screens/library_screen.dart';
import 'package:codeway/services/firestore_seed_service.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:codeway/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:codeway/widgets/custom_button.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

                        buttonFill: Color(0xFFD4D5EA),
                        buttonBorder: Color(0xFFBEBFD4),
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

                        buttonFill: Color(0xFF23232D),
                        buttonBorder: Color(0xFF3E3E50),
                        buttonText: Color(0xFFFFFFFF),
                    ),
                ],
            ),
            home: MainScreen(),
        );
    }
}

class MainScreen extends StatelessWidget {
    const MainScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: context.colors.mainBackground,
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Text(
                                        'CodeWay',
                                        style: TextStyle(
                                            color: context.colors.mainElements,
                                            fontSize: 24,
                                            fontWeight: FontWeight(700),
                                        ),
                                    ),

                                    IconButton(
                                        icon: const Icon(Icons.account_circle_outlined),
                                        color: context.colors.mainElements,
                                        iconSize: 55,
                                        onPressed: () {},
                                    ),
                                ],
                            ),
                        ),

                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                                height: 1,
                                thickness: 1,
                                color: context.colors.buttonBorder.withValues(alpha: 0.35),
                            ),
                        ),

                        const Spacer(),

                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                                'Добро пожаловать в мир IT профессий!',
                                style: TextStyle(
                                    color: context.colors.mainElements,
                                    fontSize: 24,
                                    fontWeight: FontWeight(700),
                                ),
                                textAlign: TextAlign.center,
                            ),
                        ),

                        Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    CustomButton(
                                        text: 'Карта',
                                        onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const MapScreen(),
                                                ),
                                            );
                                        },
                                    ),

                                    const SizedBox(height: 20),

                                    Text(
                                        'Интерактивный путеводитель',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight(500)),
                                    ),

                                    const SizedBox(height: 50),

                                    CustomButton(
                                        text: 'Библиотека',
                                        onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => const LibraryScreen(),
                                                ),
                                            );
                                        },
                                    ),

                                    const SizedBox(height: 20),

                                    Text(
                                        'Сборник направлений и специальностей с материалами для изучения',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight(500)),
                                        textAlign: TextAlign.center,
                                    ),
                                ],
                            ),
                        ),

                        const Spacer(),
                    ],
                ),
            ),
        );
    }
}
