import 'package:flutter/material.dart';
import '../../data/models/plant_analysis_model.dart';

class DetailsScreen extends StatelessWidget {
  final PlantAnalysisModel analysis;

  const DetailsScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل العناية الكاملة', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Names Header
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
            const SizedBox(height: 24),

            // Card 1: Botanical Information (معلومات نباتية)
            _buildSectionCard(
              context,
              title: 'التصنيف والموطن',
              icon: Icons.eco_rounded,
              color: theme.colorScheme.primary,
              children: [
                _buildRowDetail('العائلة النباتية', analysis.family),
                _buildRowDetail('الموطن الأصلي', analysis.origin),
                _buildRowDetail('الانتشار الجغرافي', analysis.countries),
                _buildRowDetail('طبيعة النمو والبيئة', analysis.environment),
                _buildRowDetail('معدل النمو', analysis.growthRate),
                _buildRowDetail('العمر الافتراضي', analysis.lifespan),
              ],
            ),
            const SizedBox(height: 20),

            // Card 2: Care Requirements (متطلبات العناية)
            _buildSectionCard(
              context,
              title: 'شروط البيئة والعناية',
              icon: Icons.wb_sunny_rounded,
              color: Colors.orange,
              children: [
                _buildRowDetail('الإضاءة المطلوبة', analysis.sunlight),
                _buildRowDetail('درجات الحرارة المثالية', analysis.temperature),
                _buildRowDetail('الرطوبة المناسبة', analysis.humidity),
                _buildRowDetail('التربة المقترحة', analysis.soil),
                _buildRowDetail('جدول الري الموصى به', analysis.wateringSchedule),
                _buildRowDetail('برنامج التسميد الموصى به', analysis.fertilizerSchedule),
              ],
            ),
            const SizedBox(height: 20),

            // Card 3: Toxicity & Toxicity Alerts (السمية والتحذيرات)
            _buildSectionCard(
              context,
              title: 'السمية والتحذيرات',
              icon: Icons.warning_rounded,
              color: theme.colorScheme.error,
              children: [
                _buildRowDetail('السمية للأطفال والحيوانات', analysis.toxicity, isHighlight: true),
              ],
            ),
            const SizedBox(height: 20),

            // Card 4: General Tips
            _buildSectionCard(
              context,
              title: 'نصائح رعاية عامة',
              icon: Icons.favorite_rounded,
              color: Colors.pink,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    analysis.generalCareTips,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRowDetail(String label, String value, {bool isHighlight = false}) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  color: isHighlight ? theme.colorScheme.error : theme.colorScheme.onSurface,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
