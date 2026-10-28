import 'package:codeway/app_colors.dart';
import 'package:codeway/models/profession_model.dart';
import 'package:codeway/services/library_service.dart';
import 'package:codeway/widgets/profession_details_dialog.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
    const LibraryScreen({super.key});

    @override
    State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
    final LibraryService _libraryService = LibraryService();
    late final Future<List<LibraryCategory>> _categoriesFuture;

    @override
    void initState() {
        super.initState();
        _categoriesFuture = _libraryService.getCategoriesWithProfessions();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: context.colors.mainBackground,
            body: SafeArea(
                child: Column(
                    children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
                            child: Row(
                                children: [
                                    IconButton(
                                        tooltip: 'Назад',
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(
                                            Icons.arrow_back,
                                            color: context.colors.mainElements,
                                        ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                        'Библиотека',
                                        style: TextStyle(
                                            color: context.colors.mainElements,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                                height: 1,
                                thickness: 1,
                                color: context.colors.buttonBorder.withValues(alpha: 0.35),
                            ),
                        ),
                        Expanded(
                            child: FutureBuilder<List<LibraryCategory>>(
                                future: _categoriesFuture,
                                builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                    }

                                    if (snapshot.hasError) {
                                        return Center(
                                            child: Padding(
                                                padding: const EdgeInsets.all(24),
                                                child: Text(
                                                    'Не удалось загрузить библиотеку:\n${snapshot.error}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: context.colors.mainElements),
                                                ),
                                            ),
                                        );
                                    }

                                    final categories = snapshot.data ?? [];
                                    if (categories.isEmpty) {
                                        return Center(
                                            child: Text(
                                                'Категории не найдены',
                                                style: TextStyle(color: context.colors.mainElements),
                                            ),
                                        );
                                    }

                                    return ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                                        itemCount: categories.length,
                                        separatorBuilder: (context, index) =>
                                                const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                            return _CategoryExpansionTile(
                                                category: categories[index],
                                                onProfessionTap: (profession) =>
                                                        _showProfession(profession),
                                            );
                                        },
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    void _showProfession(Profession profession) {
        showDialog<void>(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.black.withValues(alpha: 0.65),
            builder: (context) => ProfessionDetailsDialog(profession: profession),
        );
    }
}

class _CategoryExpansionTile extends StatelessWidget {
    final LibraryCategory category;
    final ValueChanged<Profession> onProfessionTap;

    const _CategoryExpansionTile({
        required this.category,
        required this.onProfessionTap,
    });

    @override
    Widget build(BuildContext context) {
        final colors = context.colors;

        return Theme(
            data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: colors.buttonBorder.withValues(alpha: 0.15),
                highlightColor: colors.buttonBorder.withValues(alpha: 0.08),
            ),
            child: Container(
                decoration: BoxDecoration(
                    color: colors.buttonFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.buttonBorder, width: 2),
                ),
                child: ExpansionTile(
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                    ),
                    iconColor: colors.mainElements,
                    collapsedIconColor: colors.mainElements,
                    title: Text(
                        category.name,
                        style: TextStyle(
                            color: colors.mainElements,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                    subtitle: Text(
                        '${category.professions.length} профессий',
                        style: TextStyle(
                            color: colors.mainElements.withValues(alpha: 0.7),
                            fontSize: 12,
                        ),
                    ),
                    children: [
                        if (category.professions.isEmpty)
                            Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                    'В этой категории пока нет профессий',
                                    style: TextStyle(
                                        color: colors.mainElements.withValues(alpha: 0.7),
                                    ),
                                ),
                            )
                        else
                            for (
                                var index = 0;
                                index < category.professions.length;
                                index++
                            ) ...[
                                Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    color: colors.buttonBorder.withValues(alpha: 0.35),
                                ),
                                ListTile(
                                    leading: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: colors.buttonBorder,
                                        child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                                color: colors.mainElements,
                                                fontWeight: FontWeight.w700,
                                            ),
                                        ),
                                    ),
                                    title: Text(
                                        category.professions[index].title,
                                        style: TextStyle(
                                            color: colors.mainElements,
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                    trailing: Icon(
                                        Icons.chevron_right,
                                        color: colors.mainElements,
                                    ),
                                    onTap: () => onProfessionTap(category.professions[index]),
                                ),
                            ],
                    ],
                ),
            ),
        );
    }
}
