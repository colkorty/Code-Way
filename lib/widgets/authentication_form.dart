import 'package:codeway/app_colors.dart';
import 'package:codeway/services/authentication_service.dart';
import 'package:codeway/widgets/custom_button.dart';
import 'package:flutter/material.dart';

enum _AuthenticationMode {
    signIn,
    signUp,
}

class AuthenticationForm extends StatefulWidget {
    const AuthenticationForm({super.key});

    @override
    State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmationController = TextEditingController();

    _AuthenticationMode _mode = _AuthenticationMode.signIn;
    bool _isSubmitting = false;
    bool _isPasswordVisible = false;
    bool _isConfirmationVisible = false;
    bool _easterEggWasShown = false;
    final AuthenticationService _authenticationService = AuthenticationService();

    bool get _isSignUp => _mode == _AuthenticationMode.signUp;

    @override
    void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        _confirmationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return _buildAuthenticationForm();
    }

    Widget _buildAuthenticationForm() {
        final colors = context.colors;

        return Form(
            key: _formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Text(
                        _isSignUp ? 'Создать аккаунт' : 'Войти в аккаунт',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colors.mainElements,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                        children: [
                            Expanded(
                                child: CustomButton(
                                    text: 'Войти',
                                    maxWidth: 200,
                                    maxHeight: 64,
                                    isSelected: !_isSignUp,
                                    onTap: () => _selectMode(_AuthenticationMode.signIn),
                                ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: CustomButton(
                                    text: 'Регистрация',
                                    maxWidth: 200,
                                    maxHeight: 64,
                                    isSelected: _isSignUp,
                                    onTap: () => _selectMode(_AuthenticationMode.signUp),
                                ),
                            ),
                        ],
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                        key: const ValueKey<String>('password'),
                        controller: _passwordController,
                        label: 'Пароль',
                        obscureText: !_isPasswordVisible,
                        autofillHints: [
                            _isSignUp ? AutofillHints.newPassword : AutofillHints.password,
                        ],
                        suffixIcon: IconButton(
                            tooltip: _isPasswordVisible
                                ? 'Скрыть пароль'
                                : 'Показать пароль',
                            onPressed: () {
                                setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                });
                            },
                            icon: Icon(
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                color: colors.mainElements,
                            ),
                        ),
                        validator: _validatePassword,
                    ),
                    AnimatedSize(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            reverseDuration: const Duration(milliseconds: 350),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: _buildFieldTransition,
                            child: _isSignUp
                                ? Padding(
                                    key: const ValueKey<String>('confirmation'),
                                    padding: const EdgeInsets.only(top: 16),
                                    child: _buildTextField(
                                        controller: _confirmationController,
                                        label: 'Подтверждение пароля',
                                        obscureText: !_isConfirmationVisible,
                                        autofillHints: const [AutofillHints.newPassword],
                                        suffixIcon: IconButton(
                                            tooltip: _isConfirmationVisible
                                                ? 'Скрыть пароль'
                                                : 'Показать пароль',
                                            onPressed: () {
                                                setState(() {
                                                    _isConfirmationVisible =
                                                        !_isConfirmationVisible;
                                                });
                                            },
                                            icon: Icon(
                                                _isConfirmationVisible
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: colors.mainElements,
                                            ),
                                        ),
                                        onChanged: _checkEasterEgg,
                                        validator: _validateConfirmation,
                                    ),
                                )
                                : const SizedBox(
                                    key: ValueKey<String>('no_confirmation'),
                                ),
                        ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                        text: _isSignUp ? 'Создать аккаунт' : 'Войти',
                        maxWidth: 280,
                        maxHeight: 72,
                        isSelected: !_isSubmitting,
                        onTap: _isSubmitting ? () {} : _submit,
                    ),
                    if (_isSubmitting) ...[
                        const SizedBox(height: 16),
                        Center(
                            child: CircularProgressIndicator(
                                color: colors.mainElements,
                            ),
                        ),
                    ],
                ],
            ),
        );
    }

    Widget _buildFieldTransition(Widget child, Animation<double> animation) {
        final isLeaving = animation.status == AnimationStatus.reverse;
        final slide = isLeaving
            ? Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, 0.25),
            )
            : Tween<Offset>(
                begin: const Offset(0, -0.25),
                end: Offset.zero,
            );

        return FadeTransition(
            opacity: animation,
            child: SlideTransition(
                position: slide.animate(
                    CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                    ),
                ),
                child: child,
            ),
        );
    }

    Widget _buildTextField({
        Key? key,
        required TextEditingController controller,
        required String label,
        required String? Function(String?) validator,
        TextInputType? keyboardType,
        List<String>? autofillHints,
        bool obscureText = false,
        Widget? suffixIcon,
        ValueChanged<String>? onChanged,
    }) {
        final colors = context.colors;

        return TextFormField(
            key: key,
            controller: controller,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            obscureText: obscureText,
            validator: validator,
            onChanged: onChanged,
            style: TextStyle(color: colors.mainElements),
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    color: colors.mainElements.withValues(alpha: 0.7),
                ),
                suffixIcon: suffixIcon,
                filled: true,
                fillColor: colors.fill,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: colors.border,
                        width: 2,
                    ),
                ),
                errorStyle: TextStyle(
                    color: colors.mainElements,
                    fontWeight: FontWeight.w600,
                ),
            ),
        );
    }

    String? _validateEmail(String? value) {
        final email = value?.trim() ?? '';
        if (email.isEmpty) return 'Введите email';
        if (!email.contains('@') || email.endsWith('@')) {
            return 'Введите корректный email';
        }
        return null;
    }

    String? _validatePassword(String? value) {
        if (value == null || value.isEmpty) return 'Введите пароль';
        if (value.length < 6) {
            return 'Пароль должен содержать минимум 6 символов';
        }
        return null;
    }

    void _checkEasterEgg(String value) {
        final isEasterEgg = value.trim().toLowerCase() == 'подтвержаю';
        if (isEasterEgg && !_easterEggWasShown) {
            _easterEggWasShown = true;
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('пароль введите второй раз)')),
            );
        } else if (!isEasterEgg) {
            _easterEggWasShown = false;
        }
    }

    String? _validateConfirmation(String? value) {
        if (value == null || value.isEmpty) {
            return 'Повторите пароль';
        }
        if (value != _passwordController.text) {
            return 'Пароли не совпадают';
        }
        return null;
    }

    void _selectMode(_AuthenticationMode mode) {
        if (_isSubmitting || _mode == mode) return;

        setState(() {
            _mode = mode;
            _passwordController.clear();
            _confirmationController.clear();
            _isPasswordVisible = false;
            _isConfirmationVisible = false;
            _easterEggWasShown = false;
        });
        _formKey.currentState?.reset();
    }

    Future<void> _submit() async {
        if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
            return;
        }

        setState(() {
            _isSubmitting = true;
        });

        try {
            final email = _emailController.text.trim();

            if (_isSignUp) {
                await _authenticationService.createAccount(
                    email: email,
                    password: _passwordController.text,
                );
            } else {
                await _authenticationService.signIn(
                    email: email,
                    password: _passwordController.text,
                );
            }

            if (mounted) {
                Navigator.of(context).pop();
            }
        } on AuthenticationException catch (error) {
            _showError(error.message);
        } catch (error) {
            _showError('Не удалось выполнить авторизацию: $error');
        } finally {
            if (mounted) {
                setState(() {
                    _isSubmitting = false;
                });
            }
        }
    }

    void _showError(String message) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
        );
    }
}
