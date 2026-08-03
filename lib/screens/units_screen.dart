import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/book_model.dart';
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
                bookColor: widget.book.color,
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
