import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getCategoriesFromFirebase() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return {
            'id': doc.id,
            'name': data['name'] ?? 'No name',
            'order': data['order'] ?? 0,
        };
    }).toList();
}
