import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/post_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
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
      Provider.of<AuthProvider>(context, listen: false).tryAutoLogin().then((_) {
        print("AutoLogin complete");
      });
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevBlog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
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
          return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
