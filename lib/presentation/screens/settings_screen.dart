import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _apiKeyController.text = appState.apiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.setApiKey(_apiKeyController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الإعدادات بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد من رغبتك في حذف سجل الفحوصات بالكامل؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                final appState = Provider.of<AppState>(context, listen: false);
                await appState.clearAllHistory();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم مسح السجل بنجاح'),
                    ),
                  );
                }
              },
              child: const Text('حذف الكل', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Settings Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.vpn_key_rounded, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'إعدادات مفتاح API',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'مفتاح Gemini API Key مطلوب لتحليل صور النباتات وتشغيل المساعد الذكي. يمكنك الحصول على مفتاح مجاني من Google AI Studio.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiKeyController,
                      decoration: InputDecoration(
                        labelText: 'Gemini API Key',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _apiKeyController.clear(),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('حفظ المفتاح'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Data Management Card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.storage_rounded, color: theme.colorScheme.error),
                        const SizedBox(width: 8),
                        Text(
                          'إدارة البيانات',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.delete_sweep_rounded, color: theme.colorScheme.error),
                      title: const Text('مسح سجل الفحوصات'),
                      subtitle: const Text('حذف جميع الصور والتحاليل المحفوظة محلياً'),
                      onTap: _confirmClearHistory,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // About Section
            Center(
              child: Column(
                children: [
                  const Text(
                    'طبيب النباتات الذكي AI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الإصدار 1.0.0',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
