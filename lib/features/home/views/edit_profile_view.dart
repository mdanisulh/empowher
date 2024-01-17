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
  final bool willPop;
  const EditProfileView({super.key, this.willPop = false});
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
      if (widget.willPop) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
      }
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
            backgroundColor: Colors.deepPurpleAccent.shade700,
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
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.deepPurpleAccent.shade200,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
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
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: ageController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: selected,
                        hint: const Text(
                          'Gender',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
                      RoundedSmallButton(
                        onTap: updateUserData,
                        label: 'Update',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
