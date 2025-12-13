import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class WelcomeBonusPopup extends StatefulWidget {
  final String userName;
  final int bonusPoints;
  final VoidCallback onDismiss;

  const WelcomeBonusPopup({
    Key? key,
    required this.userName,
    this.bonusPoints = 100,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<WelcomeBonusPopup> createState() => _WelcomeBonusPopupState();
}

class _WelcomeBonusPopupState extends State<WelcomeBonusPopup>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<ConfettiParticle> _confettiParticles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateConfetti();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeIn,
    );

    _scaleController.forward();
    _confettiController.repeat();
  }

  void _generateConfetti() {
    for (int i = 0; i < 50; i++) {
      _confettiParticles.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble() * 0.3,
        color: _getRandomColor(),
        size: _random.nextDouble() * 8 + 4,
        speed: _random.nextDouble() * 2 + 1,
        angle: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFEED056),
      const Color(0xFFFFC107),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF5722),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background overlay
          GestureDetector(
            onTap: widget.onDismiss,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Confetti animation
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(
                  particles: _confettiParticles,
                  progress: _confettiController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
          // Popup content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 32.w),
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEED056).withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Close button
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: widget.onDismiss,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 18.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      // Celebration icon
                      Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFEED056),
                              Color(0xFFFFC107),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEED056).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.celebration,
                          size: 35.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      // Congratulations text
                      Text(
                        'Congratulations!',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF232323),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Welcome message
                      Text(
                        'Welcome to Aadab, ${widget.userName}!',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      // Bonus reward container
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFEED056).withOpacity(0.15),
                              const Color(0xFFFFC107).withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFEED056).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.card_giftcard,
                              size: 28.sp,
                              color: const Color(0xFFEED056),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Bonus',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF909090),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: const Color(0xFFEED056),
                                      size: 18.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${widget.bonusPoints} Points',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF232323),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Description text
                      Text(
                        'Use your bonus points to get discounts on your next purchase!',
                        textAlign: TextAlign.center,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF909090),
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // OK Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onDismiss,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEED056),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'OK',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  Color color;
  double size;
  double speed;
  double angle;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(1 - progress * 0.5)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width +
          sin(particle.angle + progress * 10) * 30;
      final y = particle.y * size.height +
          progress * size.height * particle.speed;

      if (y < size.height) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(progress * particle.angle * 2);

        // Draw different shapes for variety
        if (particles.indexOf(particle) % 3 == 0) {
          // Circle
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
        } else if (particles.indexOf(particle) % 3 == 1) {
          // Rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
        } else {
          // Triangle
          final path = Path()
            ..moveTo(0, -particle.size / 2)
            ..lineTo(particle.size / 2, particle.size / 2)
            ..lineTo(-particle.size / 2, particle.size / 2)
            ..close();
          canvas.drawPath(path, paint);
        }

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Helper function to show the welcome bonus popup
void showWelcomeBonusPopup({
  required BuildContext context,
  required String userName,
  int bonusPoints = 100,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Welcome Bonus Popup',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return WelcomeBonusPopup(
        userName: userName,
        bonusPoints: bonusPoints,
        onDismiss: () => Navigator.of(context).pop(),
      );
    },
  );
}
