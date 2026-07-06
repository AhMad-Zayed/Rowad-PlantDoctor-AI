import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant_analysis_model.dart';

class HistoryItem {
  final String id;
  final String imagePath;
  final String date;
  final PlantAnalysisModel analysis;

  HistoryItem({
    required this.id,
    required this.imagePath,
    required this.date,
    required this.analysis,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] ?? '',
      imagePath: json['imagePath'] ?? '',
      date: json['date'] ?? '',
      analysis: PlantAnalysisModel.fromJson(json['analysis'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'date': date,
      'analysis': analysis.toJson(),
    };
  }
}

class HistoryService {
  static const String _historyKey = 'plant_doctor_scan_history';

  /// Loads all history items from SharedPreferences.
  Future<List<HistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey);
      if (historyJson == null) return [];

      return historyJson
          .map((item) => HistoryItem.fromJson(json.decode(item)))
          .toList()
          .reversed // Newest scans first
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Copies the picked image to the local documents folder and saves it to history.
  Future<HistoryItem> saveScan({
    required String pickedImagePath,
    required PlantAnalysisModel analysis,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final dateStr = DateTime.now().toIso8601String();

    // 1. Copy image file to documents directory to persist it
    String persistedImagePath = pickedImagePath;
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final ext = path.extension(pickedImagePath);
      final newFileName = 'scan_$id$ext';
      final newFilePath = path.join(docDir.path, newFileName);

      final originalFile = File(pickedImagePath);
      if (await originalFile.exists()) {
        final copiedFile = await originalFile.copy(newFilePath);
        persistedImagePath = copiedFile.path;
      }
    } catch (e) {
      // Fallback to original path if copying fails
    }

    final newItem = HistoryItem(
      id: id,
      imagePath: persistedImagePath,
      date: dateStr,
      analysis: analysis,
    );

    // 2. Append new scan to list
    final currentHistory = prefs.getStringList(_historyKey) ?? [];
    currentHistory.add(json.encode(newItem.toJson()));
    await prefs.setStringList(_historyKey, currentHistory);

    return newItem;
  }

  /// Deletes a scan from the history.
  Future<void> deleteScan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHistoryList = prefs.getStringList(_historyKey) ?? [];

    final updatedList = currentHistoryList.where((item) {
      try {
        final Map<String, dynamic> parsed = json.decode(item);
        if (parsed['id'] == id) {
          // Delete physical image file
          final imagePath = parsed['imagePath'];
          if (imagePath != null && imagePath.isNotEmpty) {
            final file = File(imagePath);
            if (file.existsSync()) {
              file.deleteSync();
            }
          }
          return false; // Exclude from list
        }
      } catch (e) {
        // Keep in case of parse error
      }
      return true;
    }).toList();

    await prefs.setStringList(_historyKey, updatedList);
  }

  /// Clears all scans.
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final currentHistoryList = prefs.getStringList(_historyKey) ?? [];

    for (final item in currentHistoryList) {
      try {
        final Map<String, dynamic> parsed = json.decode(item);
        final imagePath = parsed['imagePath'];
        if (imagePath != null && imagePath.isNotEmpty) {
          final file = File(imagePath);
          if (file.existsSync()) {
            file.deleteSync();
          }
        }
      } catch (e) {
        // Skip
      }
    }

    await prefs.remove(_historyKey);
  }
}
