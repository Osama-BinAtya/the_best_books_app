import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnitCard extends StatelessWidget {
  final String unitNumber;
  final String unitTitle;
  final Color bookColor;
  final VoidCallback onTap;

  const UnitCard({
    super.key,
    required this.unitNumber,
    required this.unitTitle,
    required this.bookColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = bookColor;
    final bool isLightBg = cardColor.computeLuminance() > 0.5;
    final Color contentColor = isLightBg ? Colors.black87 : Colors.white;

    // Wrap card with a Theme override so it uses the platform default font
    final baseTheme = Theme.of(context).brightness == Brightness.dark
        ? ThemeData.dark()
        : ThemeData.light();

    return Theme(
      data: Theme.of(context).copyWith(textTheme: baseTheme.textTheme),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: contentColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        unitNumber,
                        style: TextStyle(
                          color: contentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      unitTitle,
                      style: TextStyle(
                        color: contentColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: contentColor,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
