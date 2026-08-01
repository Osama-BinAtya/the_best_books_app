import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../main.dart';

// Small reusable AppBar Lottie button that toggles app theme.
class DayNightAppBarButton extends StatefulWidget {
  const DayNightAppBarButton({super.key});

  @override
  State<DayNightAppBarButton> createState() => _DayNightAppBarButtonState();
}

class _DayNightAppBarButtonState extends State<DayNightAppBarButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _isDark = false;
  bool _isAnimating = false;
  bool _compositionInitialized = false;

  @override
  void initState() {
    super.initState();
    _isDark = themeNotifier.value == ThemeMode.dark;
    _ctrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_isAnimating) return;
    _isAnimating = true;

    final nextDark = !_isDark;
    setState(() => _isDark = nextDark);
    themeNotifier.value = _isDark ? ThemeMode.dark : ThemeMode.light;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: _isDark ? Brightness.dark : Brightness.light,
      ),
    );

    // Use the progress values that match this Lottie file. Adjust if needed.
    final target = _isDark ? 0.5 : 0.0;
    if (_isDark) {
      await _ctrl.animateTo(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      await _ctrl.animateBack(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    _ctrl.value = target;
    _ctrl.stop();
    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: SizedBox(
        height: 80.h,
        width: 80.h,
        child: Lottie.asset(
          'assets/lottie/animation.json',
          controller: _ctrl,
          animate: false,
          repeat: false,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            if (!_compositionInitialized) {
              _ctrl.duration = composition.duration;
              _ctrl.value = _isDark ? 0.5 : 0.0;
              _compositionInitialized = true;
            }
          },
        ),
      ),
    );
  }
}
