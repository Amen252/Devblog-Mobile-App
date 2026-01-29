import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/post_card.dart';
import 'profile_screen.dart';
import 'post_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PostProvider>(context, listen: false).fetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DevBlog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, _) {
          if (postProvider.isLoading && postProvider.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postProvider.posts.isEmpty) {
            return const Center(child: Text('No posts yet!'));
          }

          return RefreshIndicator(
            onRefresh: postProvider.fetchPosts,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: postProvider.posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: postProvider.posts[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PostEditorScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
