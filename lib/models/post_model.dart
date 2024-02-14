class Post {
  final String text;
  final String uid;
  final List<String> imageLinks;
  final DateTime postedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final String repliedTo;

  Post({
    required this.text,
    required this.uid,
    required this.imageLinks,
    required this.postedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.repliedTo,
  });

  Post copyWith({
    String? text,
    String? uid,
    List<String>? imageLinks,
    DateTime? postedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    String? repliedTo,
  }) {
    return Post(
      text: text ?? this.text,
      uid: uid ?? this.uid,
      imageLinks: imageLinks ?? this.imageLinks,
      postedAt: postedAt ?? this.postedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'uid': uid,
      'imageLinks': imageLinks,
      'postedAt': postedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'repliedTo': repliedTo,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      text: map['text'] ?? '',
      uid: map['uid'] ?? '',
      imageLinks: List<String>.from(map['imageLinks'] ?? []),
      postedAt: DateTime.fromMillisecondsSinceEpoch(map['postedAt']),
      likes: List<String>.from(map['likes'] ?? []),
      commentIds: List<String>.from(map['commentIds'] ?? []),
      id: map['\$id'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Post(text: $text, imageLinks: $imageLinks,  postedAt: $postedAt, likes: $likes, commentIds: $commentIds, id: $id,  repliedTo: $repliedTo';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
    return other.text == text && other.imageLinks == imageLinks && other.postedAt == postedAt && other.likes == likes && other.commentIds == commentIds && other.id == id && other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^ imageLinks.hashCode ^ postedAt.hashCode ^ likes.hashCode ^ commentIds.hashCode ^ id.hashCode ^ repliedTo.hashCode;
  }
}
