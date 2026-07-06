import 'package:flutter/material.dart';

class AnalyzingScreen extends StatelessWidget {
  const AnalyzingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false, // Prevent popping by user gesture
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spinning Loader Animation
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  Icon(
                    Icons.psychology_outlined,
                    size: 50,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Status Title
              Text(
                'جاري التحليل...',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              // Status Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'يرجى الانتظار بينما نقوم بفحص النبتة واستخراج معلومات العناية وتحديد أي أمراض محتملة.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
