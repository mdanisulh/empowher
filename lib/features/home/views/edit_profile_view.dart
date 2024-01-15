import 'dart:io';

import 'package:empowher/apis/storage_api.dart';
import 'package:empowher/apis/user_api.dart';
import 'package:empowher/common/common.dart';
import 'package:empowher/features/auth/controller/auth_controller.dart';
import 'package:empowher/features/home/views/home_view.dart';
import 'package:empowher/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<EditProfileView> {
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  final List<String> gender = ['Male', 'Female', 'Other'];
  UserModel? user;
  String? selected;
  File? profilePic;
  String? photoURL;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void updateUserData() async {
    if (user == null || nameController.text.isEmpty || ageController.text.isEmpty || selected == null) {
      showSnackBar(context, 'Please fill all the fields');
      return;
    }
    if (profilePic != null) {
      photoURL = (await ref.read(storageAPIProvider).uploadFiles(files: [profilePic!])).first;
    }
    final res = await ref.read(userAPIProvider).saveUserData(uid: user!.uid, user: {
      'name': nameController.text,
      'age': int.parse(ageController.text),
      'gender': selected![0],
      'photoURL': photoURL ?? user!.photoURL,
      'email': user!.email,
    });
    nameController.clear();
    ageController.clear();
    selected = null;
    photoURL = null;
    profilePic = null;
    if (context.mounted && res == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    return File(image.path);
  }

  @override
  Widget build(BuildContext context) {
    user = ref.watch(currentUserDetailsProvider).value;
    if (user != null) {
      nameController.text = nameController.text.isNotEmpty ? nameController.text : user!.name;
      ageController.text = ageController.text.isNotEmpty
          ? ageController.text
          : user!.age.toString() != '-1'
              ? user!.age.toString()
              : '';
    }
    return user == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).logout(context: context);
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      pickImage().then((value) => setState(() {
                            profilePic = value;
                          }));
                    },
                    child: profilePic == null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user!.photoURL),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(profilePic!, scale: 100),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Age',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: selected,
                    hint: const Text('Gender'),
                    items: gender.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selected = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateUserData,
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          );
  }
}
