import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_api/screens/add_post_screen.dart';
import 'screens/posts_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpod HTTP Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddPostScreen(),
    );
  }
}
