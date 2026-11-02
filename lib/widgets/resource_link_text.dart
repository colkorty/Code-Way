import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceLinkText extends StatefulWidget {
    final String resource;
    final Color color;

    const ResourceLinkText({
        super.key,
        required this.resource,
        required this.color,
    });

    @override
    State<ResourceLinkText> createState() => _ResourceLinkTextState();
}

class _ResourceLinkTextState extends State<ResourceLinkText> {
    late final TapGestureRecognizer _linkRecognizer;

    static final _urlPattern = RegExp(r'https?://[^\s]+');

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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
        );
    }

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
