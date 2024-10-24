import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_api/providers/http_client_provider.dart';
import '../models/post.dart';
import '../utils/constants.dart';

// Provider to manage the list of posts (includes GET, PUT, DELETE simulation)
final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>((ref) {
  return PostsNotifier(ref);
});

class PostsNotifier extends StateNotifier<List<Post>> {
  final Ref ref;

  PostsNotifier(this.ref) : super([]);

  // Fetch all posts (GET request)
  Future<void> fetchPosts() async {
    final client = ref.read(httpClientProvider);
    try {
      final response =
          await client.get(Uri.parse('${Constants.baseUrl}/posts'));

      // Print out the status code and response body for debugging
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        state = data.map((json) => Post.fromJson(json)).toList();
        print('Fetched ${state.length} posts');
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Add a new post locally after successful POST request
  void addPost(Post newPost) {
    state = [...state, newPost];
  }

  // Update a post locally after successful PUT request
  void updatePost(Post updatedPost) {
    state = [
      for (final post in state)
        if (post.id == updatedPost.id) updatedPost else post
    ];
  }

  // Remove a post locally after successful DELETE request
  void deletePost(int postId) {
    state = state.where((post) => post.id != postId).toList();
  }
}

// Provider to post data (POST request)
final postDataProvider =
    FutureProvider.family<Post, Post>((ref, newPost) async {
  final client = ref.read(httpClientProvider);
  final response = await client.post(
    Uri.parse('${Constants.baseUrl}/posts'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(newPost.toJson()),
  );

  if (response.statusCode == 201) {
    // Simulate adding the post locally
    ref.read(postsProvider.notifier).addPost(newPost);
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create post');
  }
});

// Provider to update a post (PUT request)
final updatePostProvider =
    FutureProvider.family<Post, Post>((ref, updatedPost) async {
  final client = ref.read(httpClientProvider);
  final response = await client.put(
    Uri.parse('${Constants.baseUrl}/posts/${updatedPost.id}'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(updatedPost.toJson()),
  );

  if (response.statusCode == 200) {
    // Simulate updating the post locally
    ref.read(postsProvider.notifier).updatePost(updatedPost);
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update post');
  }
});

// Provider to delete a post (DELETE request)
final deletePostProvider =
    FutureProvider.family<void, int>((ref, postId) async {
  final client = ref.read(httpClientProvider);
  final response =
      await client.delete(Uri.parse('${Constants.baseUrl}/posts/$postId'));

  if (response.statusCode == 200) {
    // Simulate deleting the post locally
    ref.read(postsProvider.notifier).deletePost(postId);
  } else {
    throw Exception('Failed to delete post');
  }
});
