import 'package:empowher/common/common.dart';
import 'package:empowher/constants/constants.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/community/widgets/carousel_image.dart';
import 'package:empowher/features/community/widgets/my_icon.dart';
import 'package:empowher/features/community/widgets/styled_text.dart';
import 'package:empowher/models/post_model.dart';
import 'package:empowher/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_svg/svg.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return ref.watch(userDetailsProvider(post.uid)).when(
          data: (postAuthor) {
            return currentUser == null || postAuthor == null
                ? const SizedBox()
                : Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1.5, color: Pallete.black)),
                    ),
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: GestureDetector(
                                // onTap: () => Navigator.push(context, UserProfileView.route(postAuthor!)),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(postAuthor.photoURL),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text: postAuthor.name,
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Pallete.black),
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                              Text(
                                                timeago.format(post.postedAt, locale: 'en_short'),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Pallete.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  StyledText(
                                    text: post.text,
                                  ),
                                  if (post.imageLinks.isNotEmpty) CarouselImage(imageLinks: post.imageLinks),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MyIcon(
                                pathname: AssetsConstants.commentIcon,
                                text: post.commentIds.length.toString(),
                                onTap: () {
                                  // Navigator.push(context, ReplyView.route(post));
                                },
                              ),
                              LikeButton(
                                size: 25,
                                isLiked: post.likes.contains(currentUser.uid),
                                onTap: ((isLiked) async {
                                  // ref.read(postControllerProvider.notifier).likepost(post, currentUser);
                                  return !isLiked;
                                }),
                                likeBuilder: (isLiked) {
                                  return isLiked
                                      ? SvgPicture.asset(
                                          AssetsConstants.likeFilledIcon,
                                          colorFilter: const ColorFilter.mode(Pallete.red, BlendMode.srcIn),
                                        )
                                      : SvgPicture.asset(
                                          AssetsConstants.likeOutlinedIcon,
                                          colorFilter: const ColorFilter.mode(Pallete.black, BlendMode.srcIn),
                                        );
                                },
                                likeCount: post.likes.length,
                                countBuilder: (likeCount, isLiked, text) {
                                  return Text(
                                    likeCount == 0 ? 'Like' : text,
                                    style: TextStyle(
                                      color: isLiked ? Pallete.red : Pallete.black,
                                      fontSize: 15,
                                      fontWeight: isLiked ? FontWeight.bold : FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                              MyIcon(
                                pathname: AssetsConstants.viewsIcon,
                                text: (post.likes.length + post.commentIds.length).toString(),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
          error: (e, st) => ErrorPage(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}
