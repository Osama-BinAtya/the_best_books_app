import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/unit_model.dart';
import '../models/item_model.dart';

class LessonScreen extends StatefulWidget {
  final UnitModel unit;

  const LessonScreen({super.key, required this.unit});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String audioPath) async {
    if (audioPath.isEmpty) return;
    try {
      await _audioPlayer.stop();
      final cleanPath = audioPath.startsWith('assets/')
          ? audioPath.replaceFirst('assets/', '')
          : audioPath;

      await _audioPlayer.play(AssetSource(cleanPath));
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pages = widget.unit.pages;
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();

    return Theme(
      data: Theme.of(context).copyWith(textTheme: baseTheme.textTheme),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: Text(widget.unit.title)),
        body: pages.isEmpty
            ? Center(
                child: Text(
                  'No pages found',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              )
            : PageView.builder(
                itemCount: pages.length,
                itemBuilder: (context, pageIndex) {
                  final page = pages[pageIndex];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = constraints.maxWidth;
                      final screenHeight = constraints.maxHeight;

                      return Container(
                        width: screenWidth,
                        height: screenHeight,
                        // لون الورقة: أبيض في الوضع الفاتح، وكحلي داكن مريح في الدارك مود
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        child: Stack(
                          children: [
                            // العناصر المتموضعة في الصفحة
                            ...page.items.map((item) {
                              return Positioned(
                                top: item.top * screenHeight,
                                left: item.left * screenWidth,
                                width: item.width * screenWidth,
                                child: _buildIndependentItem(item, isDark),
                              );
                            }),

                            // رقم الصفحة
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.black26
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Page ${page.pageNumber} / ${pages.length}',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  // بناء العناصر بحيث تتغير ألوان النصوص تلقائياً بحسب الثيم
  Widget _buildIndependentItem(ItemModel item, bool isDark) {
    return GestureDetector(
      onTap: () => _playSound(item.audioPath),
      behavior: HitTestBehavior.opaque,
      child: item.type == 'image'
          ? Image.asset(
              item.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                size: 50.sp,
                color: isDark ? Colors.white30 : Colors.grey,
              ),
            )
          : Text(
              item.content,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
