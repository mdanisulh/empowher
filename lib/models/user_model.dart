class UserModel {
  final String uid;
  final String email;
  final String name;
  final String photoURL;
  final int age;
  final String gender;
  final List<String> followers;
  final List<String> following;
  final String bannerPic;
  final String bio;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoURL,
    required this.age,
    required this.gender,
    required this.followers,
    required this.following,
    required this.bannerPic,
    required this.bio,
  });

  UserModel copyWith({String? uid, String? email, String? name, String? photoURL, int? age, String? gender, List<String>? followers, List<String>? following, String? bannerPic, String? bio}) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bannerPic: bannerPic ?? this.bannerPic,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'photoURL': photoURL,
      'age': age,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoURL: map['photoURL'] ?? '',
      uid: map['uid'] ?? '',
      age: map['age'] ?? -1,
      gender: map['gender'] ?? 'O',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      bannerPic: map['bannerPic'] ?? '',
      bio: map['bio'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, photoURL: $photoURL, age: $age, gender: $gender, followers: $followers, following: $following, bannerPic: $bannerPic, bio: $bio)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    return other.uid == uid && other.email == email && other.name == name && other.photoURL == photoURL && other.age == age && other.gender == gender && other.followers == followers && other.following == following && other.bannerPic == bannerPic && other.bio == bio;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ email.hashCode ^ name.hashCode ^ photoURL.hashCode ^ age.hashCode ^ gender.hashCode ^ followers.hashCode ^ following.hashCode ^ bannerPic.hashCode ^ bio.hashCode;
  }
}
