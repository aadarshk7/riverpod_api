import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';

class UpdatePostScreen extends ConsumerWidget {
  final Post post;

  UpdatePostScreen({required this.post});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    titleController.text = post.title;
    bodyController.text = post.body;

    return Scaffold(
      appBar: AppBar(title: Text('Update Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedPost = Post(
                  id: post.id,
                  title: titleController.text,
                  body: bodyController.text,
                );
                final result = await ref.read(updatePostProvider(updatedPost).future);

                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post updated!')));
                  Navigator.pop(context);  // Return to the previous screen
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
