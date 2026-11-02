import 'profession_model.dart';

class Category {
    final String id;
    final String name;
    final int order;
    final List<String> pathSequence;

    const Category({
        required this.id,
        required this.name,
        required this.order,
        required this.pathSequence,
    });

    factory Category.fromFirestore(String id, Map<String, dynamic> data) {
        final rawPathSequence = data['path_sequence'];
        if (rawPathSequence is! List ||
            rawPathSequence.any((id) => id is! String)) {
            throw FormatException('В категории $id поле path_sequence должно быть списком строк.');
        }

        final rawOrder = data['order'];
        if (rawOrder != null && rawOrder is! int) {
            throw FormatException('В категории $id поле order должно быть числом.');
        }

        return Category(
            id: id,
            name: data['name'] as String? ?? 'Без названия',
            order: rawOrder as int? ?? 0,
            pathSequence: List<String>.from(rawPathSequence),
        );
    }

    LibraryCategory withProfessions(List<Profession> professions) {
        return LibraryCategory(
            category: this,
            professions: professions,
        );
    }
}

class LibraryCategory {
    final Category category;
    final List<Profession> professions;

    const LibraryCategory({
        required this.category,
        required this.professions,
    });
}
