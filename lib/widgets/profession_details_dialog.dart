import 'package:codeway/app_colors.dart';
import 'package:codeway/models/profession_model.dart';
import 'package:flutter/material.dart';
import 'package:codeway/widgets/resource_link_text.dart';

class ProfessionDetailsDialog extends StatelessWidget {
    final Profession profession;

    const ProfessionDetailsDialog({super.key, required this.profession});

    @override
    Widget build(BuildContext context) {
        final colors = context.colors;
        final screenHeight = MediaQuery.sizeOf(context).height;

        return Dialog(
            backgroundColor: colors.fill,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: colors.border, width: 3),
            ),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: 520,
                    maxHeight: screenHeight * 0.82,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                            child: Row(
                                children: [
                                    Expanded(
                                        child: Text(
                                            profession.title,
                                            style: TextStyle(
                                                color: colors.mainElements,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                            ),
                                        ),
                                    ),
                                    IconButton(
                                        tooltip: 'Закрыть',
                                        onPressed: () => Navigator.of(context).pop(),
                                        icon: Icon(Icons.close, color: colors.mainElements),
                                    ),
                                ],
                            ),
                        ),
                        _SectionDivider(color: colors.border),
                        Flexible(
                            child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        _DetailText(
                                            text: profession.shortDescription,
                                            color: colors.mainElements,
                                        ),
                                        const SizedBox(height: 16),
                                        _SectionDivider(color: colors.border),
                                        const SizedBox(height: 16),
                                        _SectionTitle(
                                            title: 'О профессии',
                                            color: colors.mainElements,
                                        ),
                                        const SizedBox(height: 8),
                                        _DetailText(
                                            text: profession.fullInfo,
                                            color: colors.mainElements,
                                        ),
                                        if (profession.skills.isNotEmpty) ...[
                                            const SizedBox(height: 16),
                                            _SectionDivider(color: colors.border),
                                            const SizedBox(height: 16),
                                            _SectionTitle(
                                                title: 'Навыки',
                                                color: colors.mainElements,
                                            ),
                                            const SizedBox(height: 8),
                                            _SkillsText(
                                                skills: profession.skills,
                                                color: colors.mainElements,
                                            ),
                                        ],
                                        if (profession.resources.isNotEmpty) ...[
                                            const SizedBox(height: 16),
                                            _SectionDivider(color: colors.border),
                                            const SizedBox(height: 16),
                                            _SectionTitle(
                                                title: 'Материалы для изучения',
                                                color: colors.mainElements,
                                            ),
                                            const SizedBox(height: 8),
                                            for (final resource in profession.resources)
                                                Padding(
                                                    padding: const EdgeInsets.only(bottom: 8),
                                                    child: ResourceLinkText(
                                                        resource: resource,
                                                        color: colors.mainElements,
                                                    ),
                                                ),
                                        ],
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}

class _SectionDivider extends StatelessWidget {
    final Color color;

    const _SectionDivider({required this.color});

    @override
    Widget build(BuildContext context) {
        return Divider(
            height: 1,
            thickness: 1,
            color: color.withValues(alpha: 0.35),
        );
    }
}

class _SectionTitle extends StatelessWidget {
    final String title;
    final Color color;

    const _SectionTitle({required this.title, required this.color});

    @override
    Widget build(BuildContext context) {
        return Text(
            title,
            style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700),
        );
    }
}

class _DetailText extends StatelessWidget {
    final String text;
    final Color color;

    const _DetailText({required this.text, required this.color});

    @override
    Widget build(BuildContext context) {
        return Text(
            text,
            style: TextStyle(color: color, fontSize: 14, height: 1.45),
        );
    }
}

class _SkillsText extends StatelessWidget {
    final List<String> skills;
    final Color color;

    const _SkillsText({required this.skills, required this.color});

    @override
    Widget build(BuildContext context) {
        return Text.rich(
            TextSpan(
                children: [
                    for (var index = 0; index < skills.length; index++) ...[
                        if (index > 0) const TextSpan(text: ' · '),
                        TextSpan(
                            text: skills[index],
                            style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                    ],
                ],
            ),
            style: TextStyle(color: color, fontSize: 14, height: 1.45),
        );
    }
}
