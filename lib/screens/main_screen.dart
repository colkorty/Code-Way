import 'package:codeway/app_colors.dart';
import 'package:codeway/screens/authentication_screen.dart';
import 'package:codeway/screens/library_screen.dart';
import 'package:codeway/screens/map_screen.dart';
import 'package:codeway/widgets/custom_button.dart';
import 'package:flutter/material.dart';

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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Text(
                                        'CodeWay',
                                        style: TextStyle(
                                            color: context.colors.mainElements,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                    IconButton(
                                        tooltip: 'Авторизация',
                                        icon: const Icon(Icons.account_circle_outlined),
                                        color: context.colors.mainElements,
                                        iconSize: 55,
                                        onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AuthenticationScreen(),
                                                ),
                                            );
                                        },
                                    ),
                                ],
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                                height: 1,
                                thickness: 1,
                                color: context.colors.border.withValues(alpha: 0.35),
                            ),
                        ),
                        const Spacer(),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                                'Добро пожаловать в мир IT профессий!',
                                style: TextStyle(
                                    color: context.colors.mainElements,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 50),
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
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                        ),
                                    ),
                                    const SizedBox(height: 50),
                                    CustomButton(
                                        text: 'Библиотека',
                                        onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LibraryScreen(),
                                                ),
                                            );
                                        },
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                        'Сборник направлений и специальностей с материалами для изучения',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                        ),
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
