import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/post_card.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'post_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens for the bottom bar
  final List<Widget> _pages = [
    const HomeView(),
    const ExploreView(),
    const BookmarksView(),
    const ProfileScreen(), // Integrated Profile Screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.dividerColor, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline_rounded),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 0 // Only show FAB on Feed page
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostEditorScreen()),
              ),
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
    );
  }
}

// --- SUB-VIEWS ---

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.terminal_rounded, color: AppTheme.primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'DevBlog',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryBar(),
          const Divider(height: 1, color: AppTheme.dividerColor),
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, postProvider, _) {
                if (postProvider.isLoading && postProvider.posts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return RefreshIndicator(
                  onRefresh: postProvider.fetchPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: postProvider.posts.length,
                    itemBuilder: (context, index) => PostCard(post: postProvider.posts[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    final categories = ['All Feed', 'Latest', 'Trending', 'Mobile'];
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, size: 64, color: AppTheme.dividerColor),
            const SizedBox(height: 16),
            const Text('Search for Topics', style: TextStyle(color: AppTheme.textSecondaryColor)),
          ],
        ),
      ),
    );
  }
}

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_outline_rounded, size: 64, color: AppTheme.dividerColor),
            const SizedBox(height: 16),
            const Text('Your bookmarks will show up here', style: TextStyle(color: AppTheme.textSecondaryColor)),
          ],
        ),
      ),
    );
  }
}
