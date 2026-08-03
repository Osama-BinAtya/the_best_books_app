import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/book_model.dart';
import '../services/local_data_service.dart';
import 'units_screen.dart';
import '../widgets/day_night_appbar_button.dart';
import '../widgets/single_book_shelf_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BookModel> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await LocalDataService().loadCurriculum();
    setState(() {
      _books = books;
      _isLoading = false;
    });
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
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: DayNightAppBarButton(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
          ? Center(
              child: Text(
                'No books found!',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 18.sp,
                ),
              ),
            )
          : GridView.builder(
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
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];

                return SingleBookShelfCard(
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
            ),
    );
  }
}
