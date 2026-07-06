import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/plant_analysis_model.dart';
import 'details_screen.dart';

class ResultsScreen extends StatelessWidget {
  final PlantAnalysisModel analysis;
  final String imagePath;
  final bool isFromHistory;

  const ResultsScreen({
    super.key,
    required this.analysis,
    required this.imagePath,
    required this.isFromHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHealthy = analysis.healthStatus.contains('سليم') || 
                      analysis.healthStatus.toLowerCase().contains('healthy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('نتائج الفحص', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (isFromHistory) {
              Navigator.of(context).pop();
            } else {
              // Go back to the main tabs screen
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Photo Banner
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: File(imagePath).existsSync()
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: theme.colorScheme.surfaceVariant,
                        child: const Icon(Icons.image_not_supported_rounded, size: 60),
                      ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Names Card
                  Text(
                    analysis.plantName,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    analysis.scientificName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Health Status Row / Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isHealthy 
                          ? theme.colorScheme.secondaryContainer 
                          : theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isHealthy 
                            ? theme.colorScheme.primary.withOpacity(0.1) 
                            : theme.colorScheme.error.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isHealthy ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                          color: isHealthy ? theme.colorScheme.primary : theme.colorScheme.error,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'حالة النبات الصحية:',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: isHealthy 
                                      ? theme.colorScheme.onSecondaryContainer.withOpacity(0.7) 
                                      : theme.colorScheme.onErrorContainer.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                analysis.healthStatus,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isHealthy 
                                      ? theme.colorScheme.onSecondaryContainer 
                                      : theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Confidence Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ثقة ${(analysis.confidence * 100).toInt()}%',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Diagnostic details (if infected)
                  if (!isHealthy) ...[
                    Text(
                      'التشخيص والتحليل:',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(context, 'اسم المشكلة / المرض', analysis.diseaseName),
                    _buildDetailItem(context, 'السبب المحتمل', analysis.diseaseCause),
                    _buildDetailItem(context, 'الأعراض الظاهرة', analysis.symptoms),
                    const SizedBox(height: 20),
                    
                    Text(
                      'العلاج والوقاية:',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(context, 'طريقة العلاج', analysis.treatment),
                    _buildDetailItem(context, 'طرق الوقاية مستقبلاً', analysis.prevention),
                  ] else ...[
                    // Healthy Plant Summary Text
                    Text(
                      'نصائح عامة للعناية:',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      analysis.generalCareTips,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(context, 'جدول الري المقترح', analysis.wateringSchedule),
                    _buildDetailItem(context, 'جدول التسميد المقترح', analysis.fertilizerSchedule),
                  ],
                  
                  const SizedBox(height: 32),

                  // Go to full details button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(analysis: analysis),
                          ),
                        );
                      },
                      icon: const Icon(Icons.menu_book_rounded),
                      label: const Text('تفاصيل العناية الكاملة للنبات'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
