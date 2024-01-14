class UserModel {
  final String uid;
  final String email;
  final String name;
  final String photoURL;
  final int age;
  final String gender;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoURL,
    required this.age,
    required this.gender,
  });

  UserModel copyWith({String? uid, String? email, String? name, String? photoURL, int? age, String? gender}) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePic': photoURL,
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
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, photoURL: $photoURL, age: $age, gender: $gender)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    return other.uid == uid && other.email == email && other.name == name && other.photoURL == photoURL && other.age == age && other.gender == gender;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ email.hashCode ^ name.hashCode ^ photoURL.hashCode ^ age.hashCode ^ gender.hashCode;
  }
}
