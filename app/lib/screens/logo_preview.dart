import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';
import '../theme/app_theme.dart';

// LogoPreviewScreen: Boggan waxaa loogu talagalay in laga qaado Screenshot loo isticmaalo App Icon.
// Waxay muujineysaa logo-ga oo weyn oo ku dhex jira Indigo background.
class LogoPreviewScreen extends StatelessWidget {
  const LogoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Indigo Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container-ka oo cad (White) si uu u muuqdo Icon professional ah
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40), // More modern square-rounded look
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.laptop_mac_rounded,
                    color: AppTheme.primaryColor,
                    size: 150,
                  );
                },
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'DevBlog',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 100),
            const Text(
              'Take a screenshot of this\nto use as your App Icon!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
