import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/book_model.dart';

// Public widget for the book card used in HomeScreen's grid.
class SingleBookShelfCard extends StatelessWidget {
  final BookModel book;
  final bool isDark;
  final VoidCallback onTap;

  const SingleBookShelfCard({
    required this.book,
    required this.isDark,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bookThemeColor = book.color;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  top: 10.h,
                  bottom: 25.h,
                  left: 18.w,
                  right: 18.w,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: bookThemeColor.withOpacity(
                            isDark ? 0.45 : 0.3,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        book.coverPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: bookThemeColor.withOpacity(0.2),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 45,
                            color: bookThemeColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const _GlassShelf(),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            book.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassShelf extends StatelessWidget {
  const _GlassShelf();

  static const _radius = 4.0;
  static const _pinOffset = 6.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 3,
      right: 3,
      bottom: 0,
      height: 88.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x18FFFFFF),
                  Color(0x06FFFFFF),
                  Color(0x10FFFFFF),
                ],
              ),
              borderRadius: BorderRadius.circular(_radius),
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                _GlassHighlight(),
                Positioned(
                  left: _pinOffset,
                  top: _pinOffset,
                  child: _ShelfPin(),
                ),
                Positioned(
                  right: _pinOffset,
                  top: _pinOffset,
                  child: _ShelfPin(),
                ),
                Positioned(
                  left: _pinOffset,
                  bottom: _pinOffset,
                  child: _ShelfPin(),
                ),
                Positioned(
                  right: _pinOffset,
                  bottom: _pinOffset,
                  child: _ShelfPin(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassHighlight extends StatelessWidget {
  const _GlassHighlight();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 14,
      right: 14,
      child: Container(
        height: 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Color(0xA6FFFFFF), Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _ShelfPin extends StatelessWidget {
  const _ShelfPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8).withOpacity(.78),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0x42000000)),
      ),
      child: const Icon(Icons.close_rounded, size: 5, color: Color(0x8A000000)),
    );
  }
}
