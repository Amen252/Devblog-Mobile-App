import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/post_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
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
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AuthProvider>(context, listen: false).tryAutoLogin());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevBlog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
        },
      ),
    );
  }
}
