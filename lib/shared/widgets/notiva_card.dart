import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import 'package:nexus_app/core/theme/theme_ext.dart';

/// Notiva yuvarlak köşeli, gölgeli, premium kart bileşeni.
class NotivaCard extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? borderRadius;
  final Border? border;
  final Gradient? gradient;
  final bool glassmorphism;

  const NotivaCard({
    super.key,
    this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.gradient,
    this.glassmorphism = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppConstants.radiusMedium;

    final cardColor = color ?? Theme.of(context).cardTheme.color ?? context.bgSurface;

    Widget cardContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: glassmorphism ? cardColor.withOpacity(0.5) : cardColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: context.dividerColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppConstants.spacing16),
            child: child,
          ),
        ),
      ),
    );

    if (glassmorphism) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.6),
                gradient: gradient,
                borderRadius: BorderRadius.circular(radius),
                border: border ?? Border.all(color: Colors.white.withOpacity(0.4), width: 1.2),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(radius),
                  child: Padding(
                    padding: padding ?? const EdgeInsets.all(AppConstants.spacing16),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return cardContent;
  }
}
