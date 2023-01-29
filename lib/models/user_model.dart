// ignore_for_file: non_constant_identifier_names

class UserModel {
  final String name;
  final String profilePic;
  final String profile_banner;
  final String email;
  final bool isAuthenticated;
  final List<String> followerCount;
  final List<String> posts;

  const UserModel({
    required this.name,
    required this.profilePic,
    required this.profile_banner,
    required this.email,
    required this.isAuthenticated,
    required this.followerCount,
    required this.posts,
  });

  @override
  String toString() {
    return 'UserModel{ name: $name, profilePic: $profilePic, profile_banner: $profile_banner, email: $email, isAuthenticated: $isAuthenticated, followerCount: $followerCount, posts: $posts,}';
  }

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? profile_banner,
    String? email,
    bool? isAuthenticated,
    List<String>? followerCount,
    List<String>? posts,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      profile_banner: profile_banner ?? this.profile_banner,
      email: email ?? this.email,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      followerCount: followerCount ?? this.followerCount,
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imgUrl': profilePic,
      'profile_banner': profile_banner,
      'email': email,
      'isAuthenticated': isAuthenticated,
      'followerCount': followerCount,
      'posts': posts,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      profilePic: map['imgUrl'] ?? '',
      profile_banner: map['profile_banner'] ?? '',
      email: map['email'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? false,
      followerCount: List<String>.from(map['followerCount']),
      posts: List<String>.from(map['posts']),
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          profilePic == other.profilePic &&
          profile_banner == other.profile_banner &&
          email == other.email &&
          isAuthenticated == other.isAuthenticated &&
          followerCount == other.followerCount &&
          posts == other.posts);

  @override
  int get hashCode =>
      name.hashCode ^
      profilePic.hashCode ^
      profile_banner.hashCode ^
      email.hashCode ^
      isAuthenticated.hashCode ^
      followerCount.hashCode ^
      posts.hashCode;

//</editor-fold>
}
