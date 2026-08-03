import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:the_best_books_app/providers/theme_provider.dart';
import 'package:the_best_books_app/screens/intro_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'The Best',
                themeMode: themeProvider.mode,
                theme: ThemeData(
                  brightness: Brightness.light,
                  fontFamily: 'Pacifico',
                  fontFamilyFallback: const ['PlaypenSansArabic'],
                  textTheme: ThemeData.light().textTheme.apply(
                    fontFamily: 'Pacifico',
                    fontFamilyFallback: const ['PlaypenSansArabic'],
                  ),
                  primaryColor: const Color(0xFF6B0282),
                  scaffoldBackgroundColor: const Color(0xFF510162),
                  cardColor: Colors.white,
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  fontFamily: 'Pacifico',
                  fontFamilyFallback: const ['PlaypenSansArabic'],
                  textTheme: ThemeData.dark().textTheme.apply(
                    fontFamily: 'Pacifico',
                    fontFamilyFallback: const ['PlaypenSansArabic'],
                  ),
                  primaryColor: const Color(0xFF6B0282),
                  scaffoldBackgroundColor: const Color(0xFF14021A),
                  cardColor: const Color(0xFF2A0A33),
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                home: const IntroScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
