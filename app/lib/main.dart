import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/post_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

// Halkani waa barta uu app-ku ka bilaawdo (Entry Point)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        // Waxaan halkan ku qeexeynaa Providers-ka maamulaya State-ka app-ka
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: const DevBlogApp(),
    ),
  );
}

class DevBlogApp extends StatefulWidget {
  const DevBlogApp({super.key});

  @override
  State<DevBlogApp> createState() => _DevBlogAppState();
}

class _DevBlogAppState extends State<DevBlogApp> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // Marka app-ka la furo, wuxuu isku dayayaa inuu qofka si toos ah u gashiyo (Auto-login)
      Future.microtask(() {
        if (mounted) {
          Provider.of<AuthProvider>(context, listen: false).tryAutoLogin().then((_) {
            print("AutoLogin complete");
          });
        }
      });
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevBlog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          // Haddii uu raryo xogta auto-login-ka, show loading screen
          if (auth.isLoading && !auth.isAuthenticated) {
            return const Scaffold(
              backgroundColor: AppTheme.backgroundColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    SizedBox(height: 16),
                    Text('Starting DevBlog...', style: TextStyle(color: AppTheme.textColor)),
                  ],
                ),
              ),
            );
          }
          // Haddii uu qofku so galay (logged in), tusi HomeScreen, haddii kale tusi LoginScreen
          return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}

