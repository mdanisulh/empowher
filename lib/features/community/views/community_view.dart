import 'package:empowher/common/common.dart';
import 'package:empowher/features/community/controller/post_controller.dart';
import 'package:empowher/features/community/views/create_post_view.dart';
import 'package:empowher/features/community/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityView extends ConsumerWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsProvider).when(
          data: (posts) => Scaffold(
            body: Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => PostCard(post: posts[index]),
                itemCount: posts.length,
              ),
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
          ),
          loading: () => const Loader(),
          error: (e, st) => ErrorPage(error: e.toString()),
        );
  }
}
