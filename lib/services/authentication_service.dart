import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationException implements Exception {
    final String message;

    const AuthenticationException(this.message);
}

class AuthenticationService {
    final FirebaseAuth _auth;

    AuthenticationService({FirebaseAuth? auth})
        : _auth = auth ?? FirebaseAuth.instance;

    Future<void> signIn({
        required String email,
        required String password,
    }) async {
        try {
            await _auth.signInWithEmailAndPassword(
                email: email,
                password: password,
            );
        } on FirebaseAuthException catch (error) {
            throw AuthenticationException(_messageForCode(error.code));
        }
    }

    Future<void> createAccount({
        required String email,
        required String password,
    }) async {
        try {
            await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password,
            );
        } on FirebaseAuthException catch (error) {
            throw AuthenticationException(_messageForCode(error.code));
        }
    }

    String _messageForCode(String code) {
        return switch (code) {
            'invalid-email' => 'Проверьте правильность email',
            'user-disabled' => 'Этот аккаунт отключён',
            'user-not-found' || 'wrong-password' || 'invalid-credential' =>
                'Неверный email или пароль',
            'email-already-in-use' => 'Аккаунт с таким email уже существует',
            'weak-password' => 'Пароль слишком простой',
            'operation-not-allowed' => 'В Firebase не включён вход по email и паролю',
            'too-many-requests' => 'Слишком много попыток. Попробуйте позже',
            'network-request-failed' => 'Проверьте подключение к интернету',
            _ => 'Ошибка авторизации: $code',
        };
    }
}
