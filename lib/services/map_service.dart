import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profession_model.dart';

class MapService {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<List<Profession>> getMapForCategory(String categoryId) async {
        final categoryDoc = await _db.collection('categories').doc(categoryId).get();

        final categoryData = categoryDoc.data();
        if (categoryData == null) return [];

        final pathSequence = categoryData['path_sequence'];
        if (pathSequence == null) return [];
        if (pathSequence is! List) {
            throw const FormatException('Категория: поле path_sequence должно быть списком.');
        }

        final professionDocs = await _db.collection('professions').get();

        final professionsById = {
            for (final doc in professionDocs.docs)
                doc.id: Profession.fromFirestore(doc.id, doc.data()),
        };
        final professions = <Profession>[];

        for (final id in pathSequence.whereType<String>()) {
            final profession = professionsById[id];
            if (profession != null) {
                professions.add(profession);
            }
        }

        return professions;
    }
}
