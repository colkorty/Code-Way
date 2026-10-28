import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

const _seedDataAsset = 'assets/firestore_seed_data.json';
const _seedVersion = 1;

Future<void> seedFirestoreData() async {
    final json = await rootBundle.loadString(_seedDataAsset);
    final decoded = jsonDecode(json);

    if (decoded is! List) {
        throw const FormatException('Firestore seed data must be a list.');
    }

    final categories = decoded.map((entry) {
        if (entry is! Map<String, dynamic>) {
            throw const FormatException('Each seed category must be an object.');
        }
        return entry;
    }).toList();

    final firestore = FirebaseFirestore.instance;
    final seedMarker = firestore
        .collection('app_metadata')
        .doc('firestore_seed_v$_seedVersion');

    await firestore.runTransaction((transaction) async {
        final markerSnapshot = await transaction.get(seedMarker);
        if (markerSnapshot.exists) {
            return;
        }

        for (final category in categories) {
            final categoryId = category['id'];
            final categoryName = category['name'];
            final categoryOrder = category['order'];
            final pathSequence = category['path_sequence'];
            final professions = category['professions'];

            if (categoryId is! String ||
                categoryName is! String ||
                categoryOrder is! int ||
                pathSequence is! List ||
                professions is! List) {
                throw FormatException('Invalid category data: $categoryId');
            }

            final professionIds = <String>[];
            for (final profession in professions) {
                if (profession is! Map<String, dynamic>) {
                    throw FormatException('Invalid profession in category: $categoryId');
                }

                final id = profession['id'];
                final title = profession['title'];
                final step = profession['step'];
                final skills = profession['skills'];
                final shortDescription = profession['short_description'];
                final fullInfo = profession['full_info'];
                final resources = profession['resources'];

                if (id is! String ||
                    title is! String ||
                    step is! int ||
                    skills is! List ||
                    shortDescription is! String ||
                    fullInfo is! String ||
                    resources is! List ||
                    skills.any((skill) => skill is! String) ||
                    resources.any((resource) => resource is! String)) {
                    throw FormatException('Invalid profession data in category: $categoryId');
                }

                professionIds.add(id);
                transaction.set(
                    firestore.collection('professions').doc(id),
                    {
                        'title': title,
                        'step': step,
                        'skills': List<String>.from(skills),
                        'short_description': shortDescription,
                        'full_info': fullInfo,
                        'resources': List<String>.from(resources),
                    },
                );
            }

            if (pathSequence.any((id) => id is! String) ||
                pathSequence.length != professionIds.length ||
                !List<String>.from(pathSequence).asMap().entries.every(
                    (entry) => entry.value == professionIds[entry.key],
                )) {
                throw FormatException('Invalid path_sequence in category: $categoryId');
            }

            transaction.set(
                firestore.collection('categories').doc(categoryId),
                {
                    'name': categoryName,
                    'order': categoryOrder,
                    'path_sequence': List<String>.from(pathSequence),
                },
            );
        }

        transaction.set(seedMarker, {
            'version': _seedVersion,
            'seeded_at': FieldValue.serverTimestamp(),
        });
    });
}
