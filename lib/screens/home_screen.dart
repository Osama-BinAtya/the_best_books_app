import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/book_model.dart';
import '../services/local_data_service.dart';
import '../main.dart';
import 'units_screen.dart';
import '../widgets/day_night_appbar_button.dart';
import '../widgets/single_book_shelf_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<BookModel>> _booksFuture;
  bool isAnimating = false;

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _booksFuture = LocalDataService().loadCurriculum();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void toggleTheme() async {
    if (isAnimating) return;

    final isDarkMode = themeNotifier.value == ThemeMode.dark;
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    final targetProgress = isDarkMode ? 0.0 : 1.0;

    isAnimating = true;
    themeNotifier.value = nextMode;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: nextMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      ),
    );

    await _lottieController.animateTo(
      targetProgress,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    _lottieController.value = targetProgress;
    _lottieController.stop();
    isAnimating = false;
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
          );
        },
      ),
    );
  }
}
