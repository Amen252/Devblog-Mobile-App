import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/post_detail_screen.dart';
import '../theme/app_theme.dart';

// PostCard: Waa qayb yar (Widget) oo loo isticmaalo in qoraal kasta lagu muujiyo liiska hore.
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
        // Marka la taabto qoraalka, wuxuu u gudbiyaa bogga faahfaahinta.
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Qaybta sare: Sawirka iyo magaca qofka qoray.
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppTheme.surfaceColor,
                    backgroundImage: NetworkImage(
                      'https://api.dicebear.com/7.x/personas/png?seed=${post.authorName}&backgroundColor=e2e8f0',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textColor),
                        ),
                        Text(
                          DateFormat('MMM dd').format(post.createdAt),
                          style: const TextStyle(color: AppTheme.textSecondaryColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final isOwner = auth.user?.id == post.authorId;
                      return isOwner 
                          ? const Icon(Icons.more_horiz, color: AppTheme.textSecondaryColor, size: 20)
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Ciwaanka qoraalka.
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Qayb yar oo ka mid ah nuxurka qoraalka.
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

              // Qaybta hoose: Qaybta uu ka tirsan yahay iyo badhamada waxqabadka.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTag('#${post.category.toLowerCase()}'),
                  Row(
                    children: [
                      _buildActionIcon(Icons.arrow_upward_rounded),
                      const SizedBox(width: 8),
                      Consumer<PostProvider>(
                        builder: (context, provider, _) {
                          final isBookmarked = provider.isBookmarked(post.id);
                          return IconButton(
                            onPressed: () => provider.toggleBookmark(post.id),
                            icon: Icon(
                              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isBookmarked ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                              size: 20,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
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

