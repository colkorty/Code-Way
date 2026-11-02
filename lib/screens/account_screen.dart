import 'package:codeway/app_colors.dart';
import 'package:codeway/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget{
    const AccountScreen({
        super.key
    });

    @override
    Widget build(BuildContext context) {
        final email = FirebaseAuth.instance.currentUser?.email;
        final _auth = AuthService();

        return SafeArea(
            child: Scaffold(
                backgroundColor: context.colors.mainBackground,
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            color: context.colors.mainElements,
                                        ),
                                    ),

                                    const SizedBox(width: 8),

                                    Text(
                                        'Аккаунт',
                                        style: TextStyle(
                                            color: context.colors.mainElements,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                ],
                            ),
                        ),

                        Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                    Padding(
                                        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Text(
                                                            'Выполнен вход в аккаунт:',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: context.colors.mainElements,
                                                            ),
                                                        ),

                                                        Text(
                                                            email ?? 'Email не указан',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: context.colors.mainElements,
                                                            ),
                                                        )
                                                    ],
                                                ),

                                                IconButton(
                                                    tooltip: 'Выход',
                                                    icon: const Icon(Icons.logout_outlined),
                                                    color: context.colors.mainElements,
                                                    iconSize: 55,
                                                    onPressed: () {
                                                        _auth.signOut();
                                                        Navigator.pop(context);
                                                    },
                                                ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}