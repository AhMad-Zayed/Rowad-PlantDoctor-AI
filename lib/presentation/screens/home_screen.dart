import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'camera_screen.dart';
import 'results_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Action to pick image from camera or gallery
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null && context.mounted) {
        // Navigate to Camera/Preview screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CameraScreen(imagePath: pickedFile.path),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل التقاط الصورة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
    final appState = Provider.of<AppState>(context);
    final history = appState.history;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'طبيب النباتات الذكي AI',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    child: Icon(Icons.account_circle, color: theme.colorScheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Welcome Message
              Text(
                'مرحباً بك',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'صوّر أي نبتة وسنساعدك على التعرف عليها والعناية بها',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Bento Style Bento Grid
              Row(
                children: [
                  // Camera Card
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _pickImage(context, ImageSource.camera),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.photo_camera_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'التقط صورة',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Gallery and Tip Cards
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          // Gallery Button
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickImage(context, ImageSource.gallery),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: theme.colorScheme.outline.withOpacity(0.1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined, color: theme.colorScheme.primary, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      'من المعرض',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Tip of the Day
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'نصيحة اليوم',
                                          style: theme.textTheme.labelLarge?.copyWith(
                                            color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'تجنب الري المفرط في الشتاء',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onSecondaryContainer,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.water_drop_rounded,
                                    color: theme.colorScheme.primary.withOpacity(0.3),
                                    size: 32,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Statistics Section
              Text(
                'إحصائياتك',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatCard(context, appState.totalScans.toString(), 'النباتات المفحوصة', theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  _buildStatCard(context, appState.healthyCount.toString(), 'النباتات السليمة', theme.colorScheme.secondary),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    context, 
                    appState.sickCount.toString(), 
                    'تحتاج علاجاً', 
                    theme.colorScheme.error,
                    isError: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Scans
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'آخر عمليات الفحص',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              if (history.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'لا توجد عمليات فحص حديثة',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: history.length > 5 ? 5 : history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final isHealthy = item.analysis.healthStatus.contains('سليم') || 
                                        item.analysis.healthStatus.toLowerCase().contains('healthy');

                      return Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                        margin: const EdgeInsets.only(left: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
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
                          child: Container(
                            width: 130,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: File(item.imagePath).existsSync()
                                              ? Image.file(File(item.imagePath), fit: BoxFit.cover)
                                              : Container(color: Colors.grey),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isHealthy ? theme.colorScheme.primary : theme.colorScheme.error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.analysis.plantName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _formatDate(item.date),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color, {bool isError = false}) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isError 
              ? theme.colorScheme.errorContainer.withOpacity(0.3) 
              : theme.colorScheme.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isError 
                ? theme.colorScheme.error.withOpacity(0.2) 
                : theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
