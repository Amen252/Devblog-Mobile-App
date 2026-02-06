import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'post_editor_screen.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isOwner = auth.user?.id == post.authorId;

    return Scaffold(
      appBar: AppBar(
        actions: isOwner
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostEditorScreen(post: post),
                      ),
                    );
                  },
                ),
                IconButton(
                  // Icon-ka tirtirista wuxuu isticmaalayaa primaryColor
                  icon: const Icon(Icons.delete_outline, color: AppTheme.primaryColor),
                  onPressed: () => _confirmDelete(context),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                post.category.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    post.authorGender == 'female'
                        ? Icons.woman_rounded
                        : Icons.man_rounded,
                    size: 24,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  post.authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 6),
                Text(
                  _formatDate(post.createdAt),
                  style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: AppTheme.dividerColor),
            const SizedBox(height: 32),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 17,
                height: 1.7,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondaryColor)),
          ),
          TextButton(
            // Shaqada tirtirista qoraalka.
            onPressed: () async {
              try {
                await Provider.of<PostProvider>(context, listen: false).deletePost(post.id);
                if (context.mounted) {
                  Navigator.pop(context); // Dialog-ga xir
                  Navigator.pop(context); // HomeScreen ku laabo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Dialog-ga xir
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }
}
