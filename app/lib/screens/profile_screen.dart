import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _selectedGender = user?.gender ?? 'male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).updateProfile(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _selectedGender,
      );
      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final user = auth.user;
    final userPosts = postProvider.posts.where((p) => p.authorId == user?.id).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            // Logout icon-ka ayaa hadda isticmaalaya primaryColor
            icon: const Icon(Icons.logout, color: AppTheme.primaryColor),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            width: 4,
                          ),
                        ),
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: const BoxDecoration(
                            color: AppTheme.backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            user?.gender == 'female'
                                ? Icons.woman_rounded
                                : Icons.man_rounded,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      if (!_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => setState(() => _isEditing = true),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_isEditing)
                    _buildEditForm(auth.isLoading)
                  else
                    _buildProfileInfo(user, userPosts.length),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Text(
                    'My Posts',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                  ),
                  const Spacer(),
                  Text(
                    '${userPosts.length} total',
                    style: const TextStyle(color: AppTheme.textSecondaryColor),
                  ),
                ],
              ),
            ),
          ),
          if (userPosts.isEmpty)
             SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.article_outlined, size: 64, color: AppTheme.dividerColor),
                    const SizedBox(height: 16),
                    const Text('No posts yet', style: TextStyle(color: AppTheme.textSecondaryColor)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PostCard(post: userPosts[index]),
                  childCount: userPosts.length,
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(dynamic user, int postCount) {
    return Column(
      children: [
        Text(
          user?.name ?? 'Guest',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textColor),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? '',
          style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatCard('Posts', '$postCount'),
            const SizedBox(width: 48),
            _buildStatCard('Gender', user?.gender.toUpperCase() ?? 'N/A'),
          ],
        ),
      ],
    );
  }

  Widget _buildEditForm(bool isLoading) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          dropdownColor: AppTheme.surfaceColor,
          decoration: const InputDecoration(
            labelText: 'Gender',
            prefixIcon: Icon(Icons.people_outline),
          ),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
            DropdownMenuItem(value: 'other', child: Text('Other')),
          ],
          onChanged: (val) => setState(() => _selectedGender = val!),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _isEditing = false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.dividerColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Cancel', style: TextStyle(color: AppTheme.textColor)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
        ),
      ],
    );
  }
}
