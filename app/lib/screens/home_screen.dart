import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/app_logo.dart';
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
        title: const AppLogo(size: 20, fontSize: 18),
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
                // Haddii xogta la soo raryo oo liisku faaruq yahay, tusi Loading.
                if (postProvider.isLoading && postProvider.posts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                // RefreshIndicator wuxuu u oggolaanayaa qofka inuu liiska hoos u jiido si loo cusubaysiiyo.
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
    final categories = ['All Feed', 'Programming', 'UI/UX', 'General'];
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
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
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

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            decoration: const InputDecoration(
              hintText: 'Search posts, topics...',
              hintStyle: TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor),
              prefixIcon: Icon(Icons.search_rounded, size: 20, color: AppTheme.textSecondaryColor),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, _) {
          final filteredPosts = provider.posts.where((post) {
            return post.title.toLowerCase().contains(_searchQuery) ||
                   post.content.toLowerCase().contains(_searchQuery) ||
                   post.category.toLowerCase().contains(_searchQuery);
          }).toList();

          if (_searchQuery.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.explore_outlined, size: 80, color: AppTheme.dividerColor),
                  const SizedBox(height: 16),
                  const Text('Discover amazing developer stories', style: TextStyle(color: AppTheme.textSecondaryColor)),
                ],
              ),
            );
          }

          if (filteredPosts.isEmpty) {
            return Center(
              child: Text('No results found for "$_searchQuery"', style: const TextStyle(color: AppTheme.textSecondaryColor)),
            );
          }

          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) => PostCard(post: filteredPosts[index]),
          );
        },
      ),
    );
  }
}

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Posts')),
      body: Consumer<PostProvider>(
        builder: (context, provider, _) {
          final bookmarks = provider.bookmarkedPosts;

          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_outline_rounded, size: 80, color: AppTheme.dividerColor),
                  const SizedBox(height: 16),
                  const Text('You haven\'t saved any posts yet', 
                    style: TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap the bookmark icon on posts to save them',
                    style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) => PostCard(post: bookmarks[index]),
          );
        },
      ),
    );
  }
}
