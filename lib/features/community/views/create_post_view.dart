import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/constants/constants.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/community/controller/post_controller.dart';
import 'package:empowher/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePostView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreatePostView(),
      );
  const CreatePostView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
  final postTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
  }

  void sharePost() {
    ref
        .read(postControllerProvider.notifier)
        .sharePost(
          images: images,
          text: postTextController.text,
          context: context,
        )
        .then((post) {
      if (post != null) Navigator.pop(context);
    });
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close, size: 30),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: RoundedSmallButton(
              onTap: sharePost,
              label: 'Post',
              backgroundColor: Pallete.blue,
              textColor: Pallete.white,
            ),
          ),
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(currentUser.photoURL),
                            radius: 30,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: postTextController,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                            contentInsertionConfiguration: ContentInsertionConfiguration(
                              allowedMimeTypes: const <String>['image/png', 'image/gif'],
                              onContentInserted: (value) async {
                                Directory tempDir = await Directory.systemTemp.createTemp();
                                File tempFile = File('${tempDir.path}/temp.gif');
                                await tempFile.writeAsBytes(value.data!);
                                images.add(tempFile);
                                setState(() {});
                              },
                            ),
                            decoration: const InputDecoration(
                              hintText: "What's happening?",
                              hintStyle: TextStyle(
                                color: Pallete.grey,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                    if (images.isNotEmpty)
                      CarouselSlider(
                        items: images.map(
                          (file) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.file(file),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          height: 400,
                          enableInfiniteScroll: false,
                        ),
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.grey,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
          ],
        ),
      ),
    );
  }
}
