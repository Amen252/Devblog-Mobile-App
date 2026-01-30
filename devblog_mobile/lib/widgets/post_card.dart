import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post_model.dart';
import '../screens/post_detail_screen.dart';
import '../theme/app_theme.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(color: AppTheme.dividerColor, width: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Author Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(
                      post.authorName[0].toUpperCase(),
                      style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          DateFormat('MMM dd').format(post.createdAt),
                          style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_horiz, color: AppTheme.textSecondaryColor, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              
              // Title
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Content snippet
              Text(
                post.content,
                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Footer: Category & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTag('#${post.category.toLowerCase()}'),
                  Row(
                    children: [
                      _buildActionIcon(Icons.arrow_upward_rounded),
                      const SizedBox(width: 20),
                      _buildActionIcon(Icons.bookmark_border_rounded),
                      const SizedBox(width: 20),
                      _buildActionIcon(Icons.share_outlined),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.dividerColor, width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Icon(icon, color: AppTheme.textSecondaryColor, size: 18);
  }
}
