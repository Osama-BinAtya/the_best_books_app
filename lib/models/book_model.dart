// هذا الكلاس يمثل الكتاب الرئيسي ويحتوي على غلافه وقائمة الوحدات التابعة له List<UnitModel>

import 'package:flutter/material.dart';
import 'unit_model.dart';

class BookModel {
  final String id;
  final String title;
  final Color color;
  final String coverPath;
  final String? detailsPath;
  final List<UnitModel> units;

  BookModel({
    required this.id,
    required this.title,
    required this.color,
    required this.coverPath,
    this.detailsPath,
    this.units = const [],
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final rawUnits = json['units'] as List<dynamic>? ?? [];
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      color: _hexToColor(json['color'] as String? ?? '#6B0282'),
      coverPath: json['coverPath'] ?? '',
      detailsPath: json['detailsPath'] as String?,
      units: rawUnits
          .map((unit) => UnitModel.fromJson(unit as Map<String, dynamic>))
          .toList(),
    );
  }

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
