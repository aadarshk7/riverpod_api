import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';

class AddPostScreen extends ConsumerWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newPost = Post(
                    id: 0,
                    title: titleController.text,
                    body: bodyController.text);
                final result = await ref.read(postDataProvider(newPost).future);

                if (result != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Post created!')));
                  Navigator.pop(context);

                  /// Return to the previous screen
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
