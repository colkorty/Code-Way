import 'package:codeway/app_colors.dart';
import 'package:codeway/models/category_model.dart';
import 'package:codeway/services/career_data_service.dart';
import 'package:codeway/widgets/direction_button.dart';
import 'package:codeway/widgets/map_node.dart';
import 'package:codeway/widgets/map_painter.dart';
import 'package:codeway/widgets/profession_details_dialog.dart';
import 'package:flutter/material.dart';
import '../models/profession_model.dart';

class MapScreen extends StatefulWidget {
    const MapScreen({super.key});

    @override
    State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
    String _selectedCategoryId = '';

    late Future<List<Category>> _categoriesFuture;
    Future<List<Profession>>? _mapFuture;
    final CareerDataService _careerDataService = CareerDataService();

    @override
    void initState() {
        super.initState();
        _categoriesFuture = _careerDataService.getCategories();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: context.colors.mainBackground,
            body: SafeArea(
                child: FutureBuilder<List<Category>>(
                    future: _categoriesFuture,
                    builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                            return Center(
                                child: Text('Ошибка загрузки категорий: ${snapshot.error}'),
                            );
                        }

                        final categories = snapshot.data ?? [];
                        if (categories.isEmpty) {
                            return const Center(child: Text('Категории не найдены'));
                        }

                        final selectedCategoryId = _selectedCategoryId.isEmpty
                            ? categories.first.id
                            : _selectedCategoryId;
                        _mapFuture ??=
                            _careerDataService.getMapForCategory(selectedCategoryId);

                        return Column(
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
                                                'Карта',
                                                style: TextStyle(
                                                    color: context.colors.mainElements,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                ),
                                            ),
                                        ],
                                    ),
                                ),

                                Container(
                                    height: 84,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categories.length,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        itemBuilder: (context, index) {
                                            final category = categories[index];
                                            final categoryId = category.id;

                                            return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                child: DirectionButton(
                                                    text: category.name,
                                                    maxWidth: 210,
                                                    isSelected: categoryId == selectedCategoryId,
                                                    onTap: () {
                                                        setState(() {
                                                            _selectedCategoryId = categoryId;
                                                            _mapFuture = _careerDataService
                                                                .getMapForCategory(categoryId);
                                                        });
                                                    },
                                                ),
                                            );
                                        },
                                    ),
                                ),

                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: context.colors.border.withValues(
                                            alpha: 0.35,
                                        ),
                                    ),
                                ),

                                const SizedBox(height: 20),

                                Expanded(
                                    child: _buildMap(_mapFuture!),
                                ),
                            ],
                        );
                    },
                ),
            ),
        );
    }

    Widget _buildMap(Future<List<Profession>> mapFuture) {
        return FutureBuilder<List<Profession>>(
            future: mapFuture,
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                    return Center(
                        child: Text('Ошибка загрузки карты: ${snapshot.error}'),
                    );
                }

                final professions = snapshot.data ?? [];
                if (professions.isEmpty) {
                    return const Center(child: Text('В этой категории пока нет профессий'));
                }

                const nodeSize = 70.0;
                const itemHeight = 180.0;
                final contentHeight = (professions.length - 1) * itemHeight + nodeSize;

                return LayoutBuilder(
                    builder: (context, constraints) {
                        final sideOffset = constraints.maxWidth * 0.25;

                        return SingleChildScrollView(
                            child: SizedBox(
                                width: constraints.maxWidth,
                                height: contentHeight,
                                child: Stack(
                                    children: [
                                        Positioned.fill(
                                            child: CustomPaint(
                                                painter: MapPainter(
                                                    count: professions.length,
                                                    lineColor: context.colors.border,
                                                    itemHeight: itemHeight,
                                                    nodeSize: nodeSize,
                                                    sideOffset: sideOffset,
                                                ),
                                            ),
                                        ),
                                        for (var index = 0; index < professions.length; index++)
                                        Positioned(
                                            left: constraints.maxWidth / 2 +
                                                    (index.isEven
                                                        ? -sideOffset
                                                        : sideOffset) -
                                                nodeSize / 2,
                                            top: index * itemHeight,
                                            child: MapNode(
                                                index: index + 1,
                                                onTap: () {
                                                    showDialog<void>(
                                                        context: context,
                                                        barrierDismissible: true,
                                                        barrierColor: Colors.black.withValues(
                                                            alpha: 0.65,
                                                        ),
                                                        builder: (context) =>
                                                            ProfessionDetailsDialog(
                                                                profession: professions[index],
                                                            ),
                                                    );
                                                },
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        );
                    },
                );
            },
        );
    }
}
