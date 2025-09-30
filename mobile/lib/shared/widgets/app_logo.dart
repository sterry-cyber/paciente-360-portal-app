import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showShadow;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const AppLogo({
    super.key,
    this.size = 60,
    this.showShadow = false,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        child: Image.asset(
          'assets/images/logo 360.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? AppTheme.primaryColor,
                borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
              ),
              child: Icon(
                Icons.local_hospital,
                size: size * 0.5,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AppLogoSmall extends StatelessWidget {
  final double size;
  final Color? backgroundColor;

  const AppLogoSmall({
    super.key,
    this.size = 32,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          'assets/images/logo 360.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(size / 2),
              ),
              child: Icon(
                Icons.local_hospital,
                size: size * 0.6,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
