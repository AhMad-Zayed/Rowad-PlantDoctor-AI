import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'results_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDate(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final difference = DateTime.now().difference(dateTime);

      if (difference.inMinutes < 60) {
        return 'قبل قليل';
      } else if (difference.inHours < 24) {
        return 'قبل ${difference.inHours} ساعة';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else if (difference.inDays < 7) {
        return 'قبل ${difference.inDays} أيام';
      } else {
        return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الفحوصات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final history = appState.history;

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_outlined,
                    size: 80,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد عمليات فحص سابقة',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'قم بالتقاط صورة لنبتتك لبدء الفحص والتشخيص.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final isHealthy = item.analysis.healthStatus.contains('سليم') || 
                                item.analysis.healthStatus.toLowerCase().contains('healthy');

              return Card(
                elevation: 0,
                color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Navigate to results screen with the saved model
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ResultsScreen(
                          analysis: item.analysis,
                          imagePath: item.imagePath,
                          isFromHistory: true,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Image Preview
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: File(item.imagePath).existsSync()
                                ? Image.file(
                                    File(item.imagePath),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: theme.colorScheme.surfaceVariant,
                                    child: const Icon(Icons.image_not_supported_rounded),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Plant Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.analysis.plantName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.analysis.scientificName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDate(item.date),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Health Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isHealthy 
                                ? theme.colorScheme.secondaryContainer 
                                : theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isHealthy 
                                      ? theme.colorScheme.primary 
                                      : theme.colorScheme.error,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isHealthy ? 'سليمة' : 'تحتاج علاجاً',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: isHealthy 
                                      ? theme.colorScheme.onSecondaryContainer 
                                      : theme.colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
