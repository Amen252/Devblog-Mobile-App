import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';

class PostEditorScreen extends StatefulWidget {
  final Post? post;

  const PostEditorScreen({super.key, this.post});

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _contentController = TextEditingController(text: widget.post?.content ?? '');
    _category = widget.post?.category ?? 'General';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final postProvider = Provider.of<PostProvider>(context, listen: false);
    try {
      if (widget.post == null) {
        await postProvider.createPost(
          _titleController.text,
          _contentController.text,
          _category,
        );
      } else {
        await postProvider.updatePost(
          widget.post!.id,
          _titleController.text,
          _contentController.text,
          _category,
        );
      }
      if (mounted) Navigator.pop(context);
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
    final isEditing = widget.post != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Post' : 'New Post'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['General', 'Tech', 'Design', 'Life']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Post Title',
                  labelText: 'Title',
                ),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Write your story...',
                  labelText: 'Content',
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                validator: (val) => val == null || val.isEmpty ? 'Content is required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update Post' : 'Publish Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
