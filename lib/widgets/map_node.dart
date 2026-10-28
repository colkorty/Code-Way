import 'package:flutter/material.dart';
import 'package:codeway/app_colors.dart';

class MapNode extends StatefulWidget {
    final int index;
    final VoidCallback onTap;

    const MapNode({
        super.key,
        required this.index,
        required this.onTap,
    });

    @override
    State<MapNode> createState() => _MapNodeState();
}

class _MapNodeState extends State<MapNode> {
    double _currentScale = 1.0;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _currentScale = 0.92),
            onTapUp: (_) => setState(() => _currentScale = 1.0),
            onTapCancel: () => setState(() => _currentScale = 1.0),
            child: AnimatedScale(
                scale: _currentScale,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        color: context.colors.buttonFill,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: context.colors.buttonBorder,
                            width: 5,
                        ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                        '${widget.index}',
                        style: TextStyle(
                            fontSize: 25,
                            color: context.colors.mainElements,
                            fontWeight: FontWeight.w800,
                        ),
                    ),
                ),
            ),
        );
    }
}
