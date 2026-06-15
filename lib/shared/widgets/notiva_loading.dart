import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_ext.dart';

/// Merkezlenmiş yükleniyor göstergesi.
class NotivaLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const NotivaLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// Shimmer efektli yükleniyor yer tutucu kart.
class NotivaShimmerCard extends StatefulWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const NotivaShimmerCard({
    super.key,
    this.height = 100,
    this.width,
    this.borderRadius = 16,
  });

  @override
  State<NotivaShimmerCard> createState() => _NotivaShimmerCardState();
}

class _NotivaShimmerCardState extends State<NotivaShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                context.bgSurfaceVariant,
                AppColors.secondaryLight,
                context.bgSurfaceVariant,
              ],
            ),
          ),
        );
      },
    );
  }
}
