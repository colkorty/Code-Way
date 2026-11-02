import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Stream<User?> get userStateChanges => _auth.authStateChanges();

    Future<User?> signWithEmail(String email, String password) async {
        try {
            UserCredential result = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password
            );

            return result.user;
        } on FirebaseAuthException catch (e) {
            print('ошибка FirebaseAuth при входе: ${e.code} - ${e.message}');
            return null;
        } catch (e) {
            print('ошибка при входе: $e');
            return null;
        }
    }

    Future<User?> registerWithEmail(String email, String password) async {
        try {
            UserCredential result = await _auth.createUserWithEmailAndPassword(
                email: email, 
                password: password
            );

            return result.user;
        } on FirebaseAuthException catch (e) {
            print('ошибка FirebaseAuth при регистрации: ${e.code} - ${e.message}');
            return null;
        } catch (e) {
            print('ошибка при регистрации: $e');
            return null;
        }
    }

    Future<User?> signInAsGuest() async {
        try {
            UserCredential result = await _auth.signInAnonymously();

            return result.user;
        } on FirebaseAuthException catch (e) {
            print('ошибка FirebaseAuth при гостевом входе: ${e.code} - ${e.message}');
            return null;
        } catch (e) {
            print('ошибка при гостевом входе: $e');
            return null;
        }
    }

    Future<void> signOut() async {
        try {
            await _auth.signOut();
        } catch (e) {
            print('ошибка при выходе: $e');
        }
    }
}