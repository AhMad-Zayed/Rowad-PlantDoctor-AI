import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'analyzing_screen.dart';
import 'results_screen.dart';

class CameraScreen extends StatelessWidget {
  final String imagePath;

  const CameraScreen({super.key, required this.imagePath});

  void _startAnalysis(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);

    // Push the full-screen loading/analyzing screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AnalyzingScreen(),
        fullscreenDialog: true,
      ),
    );

    // Run the analysis
    await appState.analyzePlantImage(imagePath);

    if (context.mounted) {
      // Pop the analyzing loader screen
      Navigator.of(context).pop();

      if (appState.errorMessage != null) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('خطأ في التحليل'),
            content: Text(appState.errorMessage!),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      } else if (appState.currentAnalysis != null) {
        // Navigate to results screen (replacing the camera preview screen)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultsScreen(
              analysis: appState.currentAnalysis!,
              imagePath: imagePath,
              isFromHistory: false,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة الصورة'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Image Preview Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _startAnalysis(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'ابدأ الفحص',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
