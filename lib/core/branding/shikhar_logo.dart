import 'package:flutter/material.dart';
import '../theme/shikhar_colors.dart';

/// Original SHIKHAR brand logo:
/// Displays the neon mountain icon with fallback to the geometric canvas emblem.
class ShikharLogo extends StatelessWidget {
  final double size;
  final bool isDark;
  final bool showText;
  final bool isPrivate;
  final bool useImage;

  const ShikharLogo({
    super.key,
    this.size = 48.0,
    this.isDark = false,
    this.showText = false,
    this.isPrivate = false,
    this.useImage = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoWidget;

    if (useImage) {
      logoWidget = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.24),
          boxShadow: [
            BoxShadow(
              color: (isPrivate ? const Color(0xFF8B5CF6) : ShikharColors.accent).withValues(alpha: 0.35),
              blurRadius: size * 0.3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.24),
          child: Image.asset(
            'assets/icons/shikhar_icon.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return CustomPaint(
                painter: _ShikharLogoPainter(isPrivate: isPrivate),
              );
            },
          ),
        ),
      );
    } else {
      logoWidget = SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _ShikharLogoPainter(isPrivate: isPrivate),
        ),
      );
    }

    if (!showText) {
      return logoWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoWidget,
        SizedBox(width: size * 0.25),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SHIKHAR',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: size * 0.42,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.2,
                color: isPrivate
                    ? const Color(0xFFA78BFA)
                    : (isDark
                        ? ShikharColors.textPrimaryDark
                        : ShikharColors.secondary),
              ),
            ),
            Text(
              isPrivate ? 'PRIVATE MODE' : 'BROWSER',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: size * 0.20,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.5,
                color: isPrivate
                    ? const Color(0xFFC4B5FD)
                    : ShikharColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShikharLogoPainter extends CustomPainter {
  final bool isPrivate;

  _ShikharLogoPainter({required this.isPrivate});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.24),
    );

    final bgPaint = Paint()
      ..shader = (isPrivate ? ShikharColors.privateGradient : ShikharColors.brandGradient)
          .createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawRRect(rrect, bgPaint);

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..color = Colors.white.withValues(alpha: 0.25);
    canvas.drawRRect(rrect, borderPaint);

    final peak1 = Path()
      ..moveTo(w * 0.50, h * 0.18)
      ..lineTo(w * 0.76, h * 0.42)
      ..lineTo(w * 0.58, h * 0.42)
      ..lineTo(w * 0.50, h * 0.32)
      ..lineTo(w * 0.36, h * 0.45)
      ..lineTo(w * 0.24, h * 0.45)
      ..close();

    final facet1Paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;
    canvas.drawPath(peak1, facet1Paint);

    final ridge = Path()
      ..moveTo(w * 0.76, h * 0.42)
      ..lineTo(w * 0.38, h * 0.60)
      ..lineTo(w * 0.24, h * 0.58)
      ..lineTo(w * 0.62, h * 0.40)
      ..close();

    final ridgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.78)
      ..style = PaintingStyle.fill;
    canvas.drawPath(ridge, ridgePaint);

    final peak2 = Path()
      ..moveTo(w * 0.50, h * 0.82)
      ..lineTo(w * 0.24, h * 0.58)
      ..lineTo(w * 0.42, h * 0.58)
      ..lineTo(w * 0.50, h * 0.68)
      ..lineTo(w * 0.64, h * 0.55)
      ..lineTo(w * 0.76, h * 0.55)
      ..close();

    final facet2Paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;
    canvas.drawPath(peak2, facet2Paint);

    final beaconPaint = Paint()..color = const Color(0xFFFACC15);
    canvas.drawCircle(Offset(w * 0.50, h * 0.18), w * 0.04, beaconPaint);
  }

  @override
  bool shouldRepaint(covariant _ShikharLogoPainter oldDelegate) =>
      oldDelegate.isPrivate != isPrivate;
}
