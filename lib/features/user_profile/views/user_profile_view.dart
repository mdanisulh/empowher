import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/user_profile/controller/user_profile_controller.dart';
import 'package:empowher/features/user_profile/views/edit_profile_view.dart';
import 'package:empowher/features/community/widgets/post_card.dart';
import 'package:empowher/models/user_model.dart';
import 'package:empowher/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel user) => MaterialPageRoute(
        builder: (context) => UserProfileView(user: user),
      );

  final UserModel user;

  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    bool isFollowing = currentUser?.following.contains(user.uid) ?? false;
    if (currentUser?.uid == user.uid) isFollowing = true;
    bool isFollower = currentUser?.followers.contains(user.uid) ?? false;
    return currentUser == null
        ? const Loader()
        : Scaffold(
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 150,
                        floating: true,
                        pinned: true,
                        snap: true,
                        flexibleSpace: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 150,
                                child: user.bannerPic.isEmpty
                                    ? Container(color: Colors.deepPurpleAccent.shade200)
                                    : SizedBox(
                                        width: double.infinity,
                                        child: Image.network(
                                          user.bannerPic,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                              Positioned(
                                top: 90,
                                bottom: 0,
                                left: 10,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage: NetworkImage(user.photoURL),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (currentUser.uid == user.uid) {
                                      Navigator.push(context, EditProfileView.route());
                                    } else {
                                      ref.read(userProfileControllerProvider.notifier).followUser(
                                            user: user,
                                            currentUser: currentUser,
                                            context: context,
                                          );
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(isFollowing ? Colors.amberAccent : Pallete.white),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(color: Pallete.white, width: 1.5),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    user.uid == currentUser.uid
                                        ? 'Edit Profile'
                                        : isFollowing
                                            ? 'Following'
                                            : 'Follow',
                                    style: TextStyle(color: isFollowing ? Pallete.white : Pallete.black, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(10).copyWith(bottom: 0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Text(user.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Pallete.black)),
                              if (isFollower) const Text('Follows you', style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 10),
                              Text(user.bio, style: const TextStyle(fontSize: 16, color: Pallete.black)),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(text: user.following.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Pallete.black)),
                                    const TextSpan(text: '\t\tFollowing', style: TextStyle(fontSize: 16, color: Pallete.black)),
                                    const WidgetSpan(child: SizedBox(width: 20)),
                                    TextSpan(text: user.followers.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Pallete.black)),
                                    const TextSpan(text: '\t\tFollowers', style: TextStyle(fontSize: 16, color: Pallete.black)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(color: Pallete.black),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: ref.watch(getUserPostsProvider(user.uid)).when(
                        data: (posts) {
                          return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return PostCard(post: post);
                            },
                          );
                        },
                        error: (e, st) => ErrorPage(error: e.toString()),
                        loading: () => const Loader(),
                      ),
                ),
              ),
            ),
          );
  }
}
