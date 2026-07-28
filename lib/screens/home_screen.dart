import 'dart:ui'; // 👈 استيراد مهم لتشغيل تأثر الزجاج الضبابي ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/book_model.dart';
import '../services/local_data_service.dart';
import '../utils/string_extensions.dart';
import '../main.dart';
import 'units_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<BookModel>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = LocalDataService().loadCurriculum();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 72.h,
        title: Text(
          'The Best',
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontStyle: FontStyle.italic,
            fontSize: 30.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentMode, child) {
              return Transform.translate(
                offset: Offset(-2.w, 0),
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.amber : const Color(0xFF9B5DE5),
                      width: 0.9,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? Colors.amber : const Color(0xFF9B5DE5))
                            .withOpacity(0.12),
                        blurRadius: 5,
                        offset: const Offset(0, 1.5),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(4.w),
                    splashRadius: 18.r,
                    icon: Icon(
                      isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                      color: isDark ? Colors.amber : const Color(0xFF0F172A),
                    ),
                    onPressed: () {
                      themeNotifier.value = isDark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<BookModel>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No books found!',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 18.sp,
                ),
              ),
            );
          }

          final books = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.only(
              top: 24.h,
              left: 16.w,
              right: 16.w,
              bottom: 16.w,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 20.h,
              childAspectRatio: 0.68,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return _SingleBookShelfCard(
                book: book,
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UnitsScreen(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SingleBookShelfCard extends StatelessWidget {
  final BookModel book;
  final bool isDark;
  final VoidCallback onTap;

  const _SingleBookShelfCard({
    required this.book,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bookThemeColor = book.color.toColor();
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
