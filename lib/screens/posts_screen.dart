import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_provider.dart';
import 'update_post_screen.dart';
import '../models/post.dart';

class PostsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider);

    // Call fetchPosts() when the screen is loaded if the state is empty
    ref.read(postsProvider.notifier).fetchPosts();

    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: postsAsyncValue.isEmpty
          ? const Center(child: Text('No posts available'))
          : ListView.builder(
              itemCount: postsAsyncValue.length,
              itemBuilder: (context, index) {
                final post = postsAsyncValue[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdatePostScreen(post: post),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await ref.read(deletePostProvider(post.id).future);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Post deleted')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
