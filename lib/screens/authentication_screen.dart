import 'package:codeway/app_colors.dart';
import 'package:codeway/widgets/authentication_form.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatelessWidget {
    const AuthenticationScreen({super.key});

    @override
    Widget build(BuildContext context) {
        final colors = context.colors;

        return Scaffold(
            backgroundColor: colors.mainBackground,
            body: SafeArea(
                child: Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
                            child: Row(
                                children: [
                                    IconButton(
                                        tooltip: 'Назад',
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(
                                            Icons.arrow_back,
                                            color: colors.mainElements,
                                        ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                        'Авторизация',
                                        style: TextStyle(
                                            color: colors.mainElements,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                                height: 1,
                                thickness: 1,
                                color: colors.border.withValues(alpha: 0.35),
                            ),
                        ),
                        Expanded(
                            child: Center(
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(24),
                                    child: ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 440),
                                        child: const AuthenticationForm(),
                                    ),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
