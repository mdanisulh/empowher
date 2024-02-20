import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/core/core.dart';
import 'package:empowher/features/community/views/create_post_view.dart';
import 'package:empowher/features/community/widgets/post_card.dart';
import 'package:empowher/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityView extends ConsumerWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.read(firestoreProvider).collection('posts').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: posts,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return ErrorPage(error: snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        final posts = snapshot.data!.docs.map((e) => Post.fromMap(e.data() as Map<String, dynamic>).copyWith(id: e.id)).toList();
        posts.sort((a, b) => b.postedAt.compareTo(a.postedAt));
        return Scaffold(
          body: ListView.builder(
            itemBuilder: (context, index) {
              return posts[index].repliedTo.isEmpty ? PostCard(post: posts[index]) : const SizedBox.shrink();
            },
            itemCount: posts.length,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, CreatePostView.route());
              },
              child: const CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                radius: 30,
                child: Icon(Icons.add, size: 35),
              ),
            ),
          ),
        );
      },
    );
  }
}
