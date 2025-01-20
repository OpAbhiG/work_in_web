import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main_screen.dart';

/// Constants for animation durations and dimensions
class _Constants {
  static const animationDuration = Duration(milliseconds: 2000);
  static const pulseDuration = Duration(milliseconds: 4000);
  static const initialDelay = Duration(milliseconds: 300);
  static const circleSize = 100.0;
  static const strokeWidth = 4.0;
  static const defaultPadding = 24.0;
  static const smallSpacing = 8.0;
  static const mediumSpacing = 16.0;
  static const largeSpacing = 32.0;
  static const maxSpacing = 48.0;
}

/// A screen that displays booking confirmation with animated success indicator
class BookingConfirmationScreen extends StatefulWidget {
  final String fullName;
  final int doctorId;
  final DateTime date;
  final String time;
  final double amount;

  const BookingConfirmationScreen({
    super.key,
    required this.fullName,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.amount,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  late final AnimationController _pulseController;
  late final Animation<double> _checkAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _backgroundScaleAnimation;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize all animations with proper curves and durations
  void _initializeAnimations() {
    try {
      _checkController = AnimationController(
        duration: _Constants.animationDuration,
        vsync: this,
      );

      _pulseController = AnimationController(
        duration: _Constants.pulseDuration,
        vsync: this,
      );

      _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _checkController,
          curve: Curves.easeInOutQuart,
        ),
      );

      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut,
        ),
      );

      _backgroundScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _checkController,
          curve: Curves.elasticOut,
        ),
      );

      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _checkController,
          curve: Curves.easeIn,
        ),
      );

      _startAnimations();
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  /// Start animations with initial delay
  void _startAnimations() {
    Future.delayed(_Constants.initialDelay, () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _checkController.forward();
        _pulseController.repeat(reverse: true);
      }
    });
  }

  /// Handle navigation to main screen
  void _navigateToMainScreen() {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navigation failed. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorScreen();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF243B6D),
        centerTitle: true,
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(_Constants.defaultPadding),
            child: _buildContent(orientation),
          );
        },
      ),
    );
  }

  Widget _buildContent(Orientation orientation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: _Constants.defaultPadding),
        if (_isLoading)
          const CircularProgressIndicator()
        else
          _buildAnimatedSuccess(),
        SizedBox(height: _Constants.largeSpacing),
        _buildConfirmationMessage(),
        SizedBox(height: _Constants.largeSpacing),
        _buildAppointmentDetails(orientation),
        SizedBox(height: _Constants.maxSpacing),
        _buildBackButton(),
      ],
    );
  }

  Widget _buildAnimatedSuccess() {
    return Semantics(
      label: 'Booking confirmation check mark',
      child: AnimatedBuilder(
        animation: Listenable.merge([_checkController, _pulseController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _backgroundScaleAnimation.value,
            child: Container(
              width: _Constants.circleSize,
              height: _Constants.circleSize,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: CustomPaint(
                    painter: CheckmarkPainter(
                      animation: _checkAnimation,
                      color: Colors.white,
                      strokeWidth: _Constants.strokeWidth,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfirmationMessage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const Text(
            'THANK YOU!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF243B6D),
            ),
          ),
          SizedBox(height: _Constants.smallSpacing),
          Text(
            'Appointment Booked Successfully',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetails(Orientation orientation) {
    return Column(
      children: [
        _buildInfoRow(
          'Date',
          'Time',
          DateFormat('MMM dd, yyyy').format(widget.date),
          widget.time,
        ),
        SizedBox(height: _Constants.mediumSpacing),
        _buildInfoRow(
          'Appointment Type',
          'Doctor',
          'Video Consultation',
          widget.fullName,
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _navigateToMainScreen,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Back to Dashboard',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: _Constants.mediumSpacing),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: _Constants.mediumSpacing),
            ElevatedButton(
              onPressed: _navigateToMainScreen,
              child: const Text('Return to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label1, String label2, String value1, String value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: _Constants.smallSpacing / 2),
              Text(
                value1,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color:Color(0xFF243B6D),


                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label2,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: _Constants.smallSpacing / 2),
              Text(
                value2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom painter for drawing the animated checkmark
class CheckmarkPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double strokeWidth;

  const CheckmarkPainter({
    required this.animation,
    required this.color,
    this.strokeWidth = 4.0,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Path path = Path();

    final double startX = size.width * 0.25;
    final double startY = size.height * 0.5;
    final double middleX = size.width * 0.45;
    final double middleY = size.height * 0.7;
    final double endX = size.width * 0.75;
    final double endY = size.height * 0.35;

    if (animation.value <= 0.5) {
      final double progress = animation.value * 2;
      path.moveTo(startX, startY);
      path.lineTo(
        startX + (middleX - startX) * progress,
        startY + (middleY - startY) * progress,
      );
    } else {
      final double progress = (animation.value - 0.5) * 2;
      path.moveTo(startX, startY);
      path.lineTo(middleX, middleY);
      path.lineTo(
        middleX + (endX - middleX) * progress,
        middleY + (endY - middleY) * progress,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}