import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'assistant_screen.dart';
import 'settings_screen.dart';
import 'camera_screen.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    AssistantScreen(),
    SettingsScreen(),
  ];

  Future<void> _openCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CameraScreen(imagePath: pickedFile.path),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تشغيل الكاميرا: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Floating Action Button for Scanning (Mobile contextual scan button)
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.document_scanner_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // Matches left-6 alignment in RTL
      
      // Custom Glassmorphism-style Bottom Navigation Bar matching Stitch Mockup
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'الرئيسية', theme),
            _buildNavItem(1, Icons.history_rounded, Icons.history_outlined, 'السجلات', theme),
            _buildNavItem(2, Icons.smart_toy_rounded, Icons.smart_toy_outlined, 'المساعد', theme),
            _buildNavItem(3, Icons.settings_rounded, Icons.settings_outlined, 'الإعدادات', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, ThemeData theme) {
    final isActive = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
              ? theme.colorScheme.secondaryContainer 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive 
                  ? theme.colorScheme.onSecondaryContainer 
                  : theme.colorScheme.onSurfaceVariant,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
