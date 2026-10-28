import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
    final Color mainBackground;
    final Color mainElements;
    final Color buttonFill;
    final Color buttonBorder;
    final Color buttonText;

    const AppColors({
        required this.mainBackground,
        required this.mainElements,
        required this.buttonFill,
        required this.buttonBorder,
        required this.buttonText,
    });

    @override
    AppColors copyWith() => this;

    @override
    AppColors lerp(ThemeExtension<AppColors>? other, double t) {
        if (other is! AppColors) return this;
        
        return AppColors(
            mainBackground: Color.lerp(mainBackground, other.mainBackground, t)!,
            mainElements: Color.lerp(mainElements, other.mainElements, t)!,
            buttonFill: Color.lerp(buttonFill, other.buttonFill, t)!,
            buttonBorder: Color.lerp(buttonBorder, other.buttonBorder, t)!,
            buttonText: Color.lerp(buttonText, other.buttonText, t)!,
        );
    }
}

extension AppColorsExtension on BuildContext {
    AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
