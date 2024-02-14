import 'package:empowher/features/community/widgets/post_card.dart';
import 'package:empowher/models/post_model.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Post post = Post.fromMap({
      "text": "This is a post #empowher #women https://google.com",
      "uid": "ZdYu5aszB8bGuLGxF613GvWAh2h1",
      "hashtags": ["#empowher", "#women"],
      // "imageLinks": [p, p, p, p],
      "postedAt": 9876543210,
      "likes": ["123", "456"],
      "commentIds": ["123", "456"],
      "id": "123",
      "repliedTo": "123",
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostCard(post: post),
            PostCard(post: post),
            PostCard(post: post),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {},
          child: const CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            radius: 30,
            child: Icon(Icons.add, size: 35),
          ),
        ),
      ),
    );
  }
}
