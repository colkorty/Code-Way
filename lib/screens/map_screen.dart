import 'package:codeway/app_colors.dart';
import 'package:codeway/services/get_categories_from_firebase.dart';
import 'package:codeway/services/map_service.dart';
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

    late Future<List<Map<String, dynamic>>> _categoriesFuture;
    Future<List<Profession>>? _mapFuture;
    final MapService _mapService = MapService();

    @override
    void initState() {
        super.initState();
        _categoriesFuture = getCategoriesFromFirebase();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: context.colors.mainBackground,
            body: FutureBuilder<List<Map<String, dynamic>>>(
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
                        ? categories.first['id'] as String
                        : _selectedCategoryId;
                    _mapFuture ??= _mapService.getMapForCategory(selectedCategoryId);

                    return Column(
                        children: [
                            const SizedBox(height: 50),
                            
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 30),
                                        child: GestureDetector(
                                            onTap: () {
                                                Navigator.pop(context);
                                            },
                                            child: Text(
                                                '❮❮',
                                                style: TextStyle(
                                                    color: context.colors.mainElements,
                                                    fontSize: 30,
                                                ),
                                            ),
                                        ),
                                    ),
                                ],
                            ),

                            const SizedBox(height: 20),

                            Container(
                                height: 84,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    itemBuilder: (context, index) {
                                        final category = categories[index];
                                        final categoryId = category['id'] as String;

                                        return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: DirectionButton(
                                                text: category['name'] as String,
                                                maxWidth: 210,
                                                isSelected: categoryId == selectedCategoryId,
                                                onTap: () {
                                                    setState(() {
                                                        _selectedCategoryId = categoryId;
                                                        _mapFuture =
                                                            _mapService.getMapForCategory(categoryId);
                                                    });
                                                },
                                            ),
                                        );
                                    },
                                ),
                            ),

                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: context.colors.buttonBorder.withValues(
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
                                                    lineColor: context.colors.buttonBorder,
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
