import 'package:codeway/app_colors.dart';
import 'package:codeway/models/profession_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionDetailsDialog extends StatelessWidget {
    final Profession profession;

    const ProfessionDetailsDialog({super.key, required this.profession});

    @override
    Widget build(BuildContext context) {
        final colors = context.colors;
        final screenHeight = MediaQuery.sizeOf(context).height;

        return Dialog(
            backgroundColor: colors.buttonFill,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: colors.buttonBorder, width: 3),
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
                        _SectionDivider(color: colors.buttonBorder),
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
                                        _SectionDivider(color: colors.buttonBorder),
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
                                            _SectionDivider(color: colors.buttonBorder),
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
                                            _SectionDivider(color: colors.buttonBorder),
                                            const SizedBox(height: 16),
                                            _SectionTitle(
                                                title: 'Материалы для изучения',
                                                color: colors.mainElements,
                                            ),
                                            const SizedBox(height: 8),
                                            for (final resource in profession.resources)
                                                Padding(
                                                    padding: const EdgeInsets.only(bottom: 8),
                                                    child: _ResourceText(
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

class _ResourceText extends StatefulWidget {
    final String resource;
    final Color color;

    const _ResourceText({required this.resource, required this.color});

    @override
    State<_ResourceText> createState() => _ResourceTextState();
}

class _ResourceTextState extends State<_ResourceText> {
    late final TapGestureRecognizer _linkRecognizer;

    @override
    void initState() {
        super.initState();
        _linkRecognizer = TapGestureRecognizer()..onTap = _openLink;
    }

    @override
    void dispose() {
        _linkRecognizer.dispose();
        super.dispose();
    }

    Future<void> _openLink() async {
        final match = _urlPattern.firstMatch(widget.resource);
        if (match == null) return;

        final url = match.group(0)!.replaceFirst(RegExp(r'[.,;:!?—]+$'), '');
        final uri = Uri.tryParse(url);
        if (uri == null) {
            _showLinkError('Ссылка имеет неверный формат');
            return;
        }

        try {
            final launched = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
            );
            if (!launched) {
                _showLinkError('Не удалось открыть ссылку');
            }
        } on MissingPluginException {
            _showLinkError('Перезапустите приложение, чтобы открыть ссылки');
        } on PlatformException {
            _showLinkError('Не удалось открыть ссылку на этом устройстве');
        }
    }

    void _showLinkError(String message) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
    }

    static final _urlPattern = RegExp(r'https?://[^\s]+');

    @override
    Widget build(BuildContext context) {
        final match = _urlPattern.firstMatch(widget.resource);
        final baseStyle = TextStyle(
            color: widget.color,
            fontSize: 14,
            height: 1.45,
        );

        if (match == null) {
            final colonIndex = widget.resource.indexOf(':');
            if (colonIndex < 0) {
                return Text('• ${widget.resource}', style: baseStyle);
            }

            return Text.rich(
                TextSpan(
                    children: [
                        const TextSpan(text: '• '),
                        TextSpan(
                            text: widget.resource.substring(0, colonIndex + 1),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: widget.resource.substring(colonIndex + 1)),
                    ],
                ),
                style: baseStyle,
            );
        }

        final url = match.group(0)!;
        return Text.rich(
            TextSpan(
                children: [
                    const TextSpan(text: '• '),
                    TextSpan(
                        text: widget.resource.substring(0, match.start),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                        text: url,
                        style: const TextStyle(color: Colors.blue),
                        recognizer: _linkRecognizer,
                    ),
                    TextSpan(text: widget.resource.substring(match.end)),
                ],
            ),
            style: baseStyle,
        );
    }
}
