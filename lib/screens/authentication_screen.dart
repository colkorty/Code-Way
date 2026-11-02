import 'package:codeway/app_colors.dart';
import 'package:codeway/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:codeway/services/auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
    final bool showBackButton;

    const AuthenticationScreen({
        this.showBackButton = true,
        super.key
    });

    @override
    State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
    bool _isLogin = true;
    bool _obscurePassword = true;
    bool _obscureConfirmPassword = true;

    final _authService = AuthService();

    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    @override
    void dispose() {
        _emailController.dispose(); 
        _passwordController.dispose();
        _confirmPasswordController.dispose();
        super.dispose();
    }

    Future<void> _submit() async {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final confirmPassword = _confirmPasswordController.text.trim();

        void showError(String message) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message))
            );
        }

        if (email.isEmpty) {
            showError('Введите email');
            return;
        }

        final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
        if (!emailPattern.hasMatch(email)) {
            showError('email имеет неправильный формат');
            return;
        }

        if (password.isEmpty) {
            showError('Введите пароль');
            return;
        }

        if (!_isLogin) {
            if (password.length < 8) {
                showError('Пароль должен содержать не менее 8 символов');
                return;
            }

            if (confirmPassword.toLowerCase() == 'подтверждаю' && password != confirmPassword) {
                showError('Введите пароль второй раз)');
                return;
            }

            if (password != confirmPassword) {
                showError('Пароли не совпадают');
                return;
            }
        }

        final user = _isLogin
            ? await _authService.signWithEmail(email, password)
            : await _authService.registerWithEmail(email, password);

        if (!mounted) return;

        if (user == null) {
            showError('Не удалось выполнить авторизацию');
        }
    }
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: context.colors.mainBackground,
            body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
                            child: Row(
                                children: [
                                    if (widget.showBackButton) ...[
                                        IconButton(
                                            tooltip: 'Назад',
                                            onPressed: () => Navigator.pop(context),
                                            icon: Icon(
                                                Icons.arrow_back,
                                                color: context.colors.mainElements,
                                            ),
                                        ),
                                        const SizedBox(width: 8),
                                    ],
                                    
                                    Text(
                                        'Авторизация',
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
                            child: LayoutBuilder(
                                builder: (context, constraints) {
                                    return SingleChildScrollView(
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minHeight: constraints.maxHeight,
                                            ),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                    Text(
                                                        _isLogin ? 'Войти в аккаунт' : 'Создать аккаунт',
                                                        style: TextStyle(
                                                            color: context.colors.mainElements,
                                                            fontSize: 25,
                                                        ),
                                                    ),

                                                    const SizedBox(height: 20,),

                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                            Opacity(
                                                                opacity: _isLogin ? 1 : 0.7,
                                                                child: CustomButton(
                                                                    text: 'Вход',
                                                                    onTap: () {
                                                                        setState(() => _isLogin = true);
                                                                    },
                                                                    maxWidth: 170,
                                                                ),
                                                            ),

                                                            const SizedBox(width: 20,),

                                                            Opacity(
                                                                opacity: !_isLogin ? 1 : 0.7, 
                                                                child: CustomButton(
                                                                    text: 'Регистрация',
                                                                    onTap: () {
                                                                        setState(() => _isLogin = false);
                                                                    },
                                                                    maxWidth: 170,
                                                                ),
                                                            ),
                                                        ],
                                                    ),

                                                    const SizedBox(height: 20,),

                                                    Padding(
                                                        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                                                        child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                                TextFormField( //email
                                                                    decoration: InputDecoration(
                                                                        hintText: 'email',
                                                                        prefixIcon: Icon(
                                                                            Icons.email_outlined,
                                                                            color: context.colors.mainElements,
                                                                        ),
                                                                        focusedBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: context.colors.mainElements),
                                                                        )
                                                                    ),
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    controller: _emailController,
                                                                ),

                                                                const SizedBox(height: 15,),

                                                                TextFormField( //password
                                                                    decoration: InputDecoration(
                                                                        hintText: 'пароль',
                                                                        prefixIcon: Icon(
                                                                            Icons.password_outlined,
                                                                            color: context.colors.mainElements,
                                                                        ),
                                                                        focusedBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: context.colors.mainElements),
                                                                        ),
                                                                        suffixIcon: IconButton(
                                                                            onPressed: () {
                                                                                setState(() {
                                                                                    _obscurePassword = !_obscurePassword;
                                                                                });
                                                                            },
                                                                            icon: Icon(
                                                                                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                    obscureText: _obscurePassword,
                                                                    controller: _passwordController,
                                                                ),

                                                                const SizedBox(height: 15,),

                                                                if (!_isLogin) ...[ //confirm password
                                                                    TextFormField(
                                                                        decoration: InputDecoration(
                                                                            hintText: 'пароль',
                                                                            prefixIcon: const Icon(Icons.password_outlined),
                                                                            suffixIcon: IconButton(
                                                                                onPressed: () {
                                                                                    setState(() {
                                                                                        _obscureConfirmPassword = !_obscureConfirmPassword;
                                                                                    });
                                                                                },
                                                                                icon: Icon(
                                                                                    _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                                                ),
                                                                            ),
                                                                            focusedBorder: UnderlineInputBorder(
                                                                                borderSide: BorderSide(color: context.colors.mainElements),
                                                                            ),
                                                                        ),
                                                                        obscureText: _obscureConfirmPassword,
                                                                        controller: _confirmPasswordController,
                                                                    ),
                                                                ]
                                                            ],
                                                        ),
                                                    ),

                                                    const SizedBox(height: 50,),

                                                    CustomButton(
                                                        text: 'Продолжить',
                                                        onTap: () {
                                                            _submit();
                                                        }
                                                    ),
                                                ],
                                            ),
                                        ),
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}