import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProgressService {
    Future<void> markProfessionViewed(String professionId) async {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
            throw StateError('Пользователь не вошёл в аккаунт');
        }

        await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
                'viewedProfessionIds': FieldValue.arrayUnion([professionId]),
            },
            SetOptions(merge: true)
        );
    }

    Stream<Set<String>> watchViewedProfessionIds() {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
            return Stream.error(
                StateError('Пользователь не вошёл в аккаунт'),
            );
        }

        return FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .map((snapshot) {
                final ids = snapshot.data()?['viewedProfessionIds'];

                if (ids == null) {
                    return <String>{};
                }

                if (ids is! List || ids.any((id) => id is! String)) {
                    throw const FormatException(
                        'viewedProfessionIds должен быть списком строк',
                    );
                }

                return Set<String>.from(ids);
            }
        );
    }
}