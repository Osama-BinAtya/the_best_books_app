import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/book_model.dart';
import '../main.dart';
import '../services/local_data_service.dart';
import '../widgets/unit_card.dart';
import 'lesson_screen.dart';

class UnitsScreen extends StatefulWidget {
  final BookModel book;

  const UnitsScreen({super.key, required this.book});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  late Future<BookModel> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = LocalDataService().loadBookDetails(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.book.title,
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontStyle: FontStyle.italic,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
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
      body: FutureBuilder<BookModel>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          final loadedBook = snapshot.data ?? widget.book;
          if (loadedBook.units.isEmpty) {
            return Center(
              child: Text(
                'No units found',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 18.sp,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: loadedBook.units.length,
            itemBuilder: (context, index) {
              final unit = loadedBook.units[index];
              return UnitCard(
                unitNumber: '${unit.order}',
                unitTitle: unit.title,
                bookColorHex: widget.book.color,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonScreen(unit: unit),
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
