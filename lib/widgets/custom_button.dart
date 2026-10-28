import 'package:codeway/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
    final String text;
    final VoidCallback onTap;
    final double maxWidth;
    final double maxHeight;
    final bool isSelected;

    const CustomButton({
        super.key,
        required this.text,
        required this.onTap,
        this.maxWidth = 200,
        this.maxHeight = 75,
        this.isSelected = true,
    });

    @override
    State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
    double _currentRadius = 30;

    @override
    Widget build(BuildContext context) {
        final buttonFillColor = context.colors.buttonFill;
        final buttonBorderColor = context.colors.buttonBorder;

        return Center(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: widget.maxWidth,
                    maxHeight: widget.maxHeight
                ),
                child: TweenAnimationBuilder(
                    tween: Tween<double>(
                        begin: _currentRadius, 
                        end: _currentRadius
                    ), 
                    duration: const Duration(milliseconds: 100), 
                    curve: Curves.easeOut,
                    builder: (context, animatedRadius, child) {
                        double currentScale = 1.0 - ((30.0 - animatedRadius) * 0.005);

                        return Opacity(
                            opacity: widget.isSelected ? 1.0 : 0.75,
                            child: GestureDetector (
                                onTap: widget.onTap,
                                onTapDown: (_) => setState(() => _currentRadius = 20.0),
                                onTapUp: (_) => setState(() => _currentRadius = 30.0),
                                onTapCancel: () => setState(() => _currentRadius = 30.0),
                                child: Transform.scale(
                                    scale: currentScale,
                                    child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 10),
                                        curve: Curves.easeOut,
                                        decoration: BoxDecoration(
                                            color: buttonFillColor,
                                            borderRadius: BorderRadius.circular(animatedRadius),
                                            border: Border.all(
                                                color: buttonBorderColor,
                                                width: 5,
                                            ),
                                        ),
                                        child: Center(
                                            child: Text(
                                                widget.text,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: context.colors.mainElements,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.5,
                                                ),
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                        );
                    }
                ),
            ),
        );
    }
}
