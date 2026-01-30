import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../theme/app_theme.dart';

class PostEditorScreen extends StatefulWidget {
  final Post? post;

  const PostEditorScreen({super.key, this.post});

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _contentController = TextEditingController(text: widget.post?.content ?? '');
    _selectedCategory = widget.post?.category ?? 'Technology';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _savePost() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    try {
      if (widget.post == null) {
        await postProvider.createPost(
          _titleController.text,
          _contentController.text,
          _selectedCategory,
        );
      } else {
        await postProvider.updatePost(
          widget.post!.id,
          _titleController.text,
          _contentController.text,
          _selectedCategory,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppTheme.accentColor),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppTheme.secondaryColor, size: 28),
            onPressed: _savePost,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s on your mind?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textColor),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Post Title',
                hintText: 'Give your post a title...',
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              dropdownColor: AppTheme.surfaceColor,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: ['Technology', 'Lifestyle', 'Education', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _contentController,
              maxLines: 12,
              style: const TextStyle(fontSize: 16, height: 1.5),
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Share your thoughts with the world...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
