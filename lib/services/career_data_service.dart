import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codeway/models/category_model.dart';
import 'package:codeway/models/profession_model.dart';

class CareerDataService {
    final FirebaseFirestore _db;

    CareerDataService({FirebaseFirestore? firestore})
        : _db = firestore ?? FirebaseFirestore.instance;

    Future<List<Category>> getCategories() async {
        final snapshot = await _db
            .collection('categories')
            .orderBy('order')
            .get();

        return snapshot.docs
            .map((doc) => Category.fromFirestore(doc.id, doc.data()))
            .toList();
    }

    Future<List<Profession>> getMapForCategory(String categoryId) async {
        final categoryDoc = await _db
            .collection('categories')
            .doc(categoryId)
            .get();
        final categoryData = categoryDoc.data();
        if (categoryData == null) return [];

        final category = Category.fromFirestore(categoryDoc.id, categoryData);
        final professionsById = await _getProfessionsById();

        return _getProfessionsInCategoryOrder(
            category.pathSequence,
            professionsById,
        );
    }

    Future<List<LibraryCategory>> getCategoriesWithProfessions() async {
        final categories = await getCategories();
        final professionsById = await _getProfessionsById();

        return categories.map((category) {
            final professions = _getProfessionsInCategoryOrder(
                category.pathSequence,
                professionsById,
            );
            return category.withProfessions(professions);
        }).toList();
    }

    Future<Map<String, Profession>> _getProfessionsById() async {
        final snapshot = await _db.collection('professions').get();

        return {
            for (final doc in snapshot.docs)
                doc.id: Profession.fromFirestore(doc.id, doc.data()),
        };
    }

    List<Profession> _getProfessionsInCategoryOrder(
        List<String> professionIds,
        Map<String, Profession> professionsById,
    ) {
        final professions = <Profession>[];

        for (final id in professionIds) {
            final profession = professionsById[id];
            if (profession != null) {
                professions.add(profession);
            }
        }

        return professions;
    }
}
