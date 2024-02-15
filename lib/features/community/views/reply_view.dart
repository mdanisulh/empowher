import 'package:empowher/features/community/controller/post_controller.dart';
import 'package:empowher/features/community/widgets/post_card.dart';
import 'package:empowher/models/post_model.dart';
import 'package:empowher/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyView extends ConsumerWidget {
  static route(Post post) => MaterialPageRoute(builder: (context) => ReplyView(post: post));
  final Post post;
  final controller = TextEditingController();
  ReplyView({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              PostCard(post: post),
              Expanded(
                child: ListView.builder(
                  itemCount: post.commentIds.length,
                  itemBuilder: (context, index) {
                    final replyId = post.commentIds[index];
                    final reply = ref.watch(getPostByIDProvider(replyId)).value;
                    if (reply == null) return const SizedBox();
                    return PostCard(post: reply);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 16),
                  maxLines: null,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(maxHeight: 150),
                    contentPadding: const EdgeInsets.all(10).copyWith(left: 20),
                    hintText: 'Reply',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Pallete.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Pallete.black, width: 2),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref.watch(postControllerProvider.notifier).sharePost(
                          images: [],
                          text: controller.text,
                          repliedTo: post.id,
                          context: context,
                        ).then((reply) {
                          if (reply != null) {
                            post.commentIds.add(reply.id);
                            ref.watch(replyPostProvider(post));
                          }
                        });
                        controller.text = '';
                      },
                      icon: const Icon(Icons.send),
                      iconSize: 25,
                      padding: const EdgeInsets.only(right: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
