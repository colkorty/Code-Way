import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codeway/models/profession_model.dart';

class LibraryCategory {
    final String id;
    final String name;
    final List<Profession> professions;

    const LibraryCategory({
        required this.id,
        required this.name,
        required this.professions,
    });
}

class LibraryService {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<List<LibraryCategory>> getCategoriesWithProfessions() async {
        final categorySnapshot = await _db
                .collection('categories')
                .orderBy('order')
                .get();
        final professionSnapshot = await _db.collection('professions').get();

        final professionsById = {
            for (final doc in professionSnapshot.docs)
                doc.id: Profession.fromFirestore(doc.id, doc.data()),
        };

        return categorySnapshot.docs.map((categoryDoc) {
            final categoryData = categoryDoc.data();
            final pathSequence = categoryData['path_sequence'];

            if (pathSequence is! List) {
                throw FormatException(
                    'В категории ${categoryDoc.id} поле path_sequence должно быть списком.',
                );
            }

            final professions = <Profession>[];
            for (final professionId in pathSequence) {
                if (professionId is! String) {
                    throw FormatException(
                        'В категории ${categoryDoc.id} найден некорректный ID профессии.',
                    );
                }

                final profession = professionsById[professionId];
                if (profession != null) {
                    professions.add(profession);
                }
            }

            return LibraryCategory(
                id: categoryDoc.id,
                name: categoryData['name'] as String? ?? 'Без названия',
                professions: professions,
            );
        }).toList();
    }
}
