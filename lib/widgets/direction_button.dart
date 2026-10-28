import 'package:codeway/app_colors.dart';
import 'package:flutter/material.dart';

class DirectionButton extends StatefulWidget {
    final String text;
    final VoidCallback onTap;
    final bool isSelected;
    final double maxWidth;

    const DirectionButton({
        super.key,
        required this.text,
        required this.onTap,
        this.isSelected = true,
        this.maxWidth = 210,
    });

    @override
    State<DirectionButton> createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<DirectionButton> {
    double _scale = 1.0;

    @override
    Widget build(BuildContext context) {
        return Opacity(
            opacity: widget.isSelected ? 1.0 : 0.75,
            child: Listener(
                onPointerDown: (_) => setState(() => _scale = 0.96),
                onPointerUp: (_) => setState(() => _scale = 1.0),
                onPointerCancel: (_) => setState(() => _scale = 1.0),
                child: GestureDetector(
                    onTap: widget.onTap,
                    child: AnimatedScale(
                        scale: _scale,
                        duration: const Duration(milliseconds: 80),
                        curve: Curves.easeOut,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: widget.maxWidth),
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 80),
                                curve: Curves.easeOut,
                                constraints: const BoxConstraints(minHeight: 48),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                    color: context.colors.buttonFill,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: context.colors.buttonBorder,
                                        width: 5,
                                    ),
                                ),
                                child: Text(
                                    widget.text,
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: context.colors.mainElements,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.3,
                                    ),
                                ),
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}
