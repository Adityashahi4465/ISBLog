// model 
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Articles {
  final String author;
  final String? bannerImage;
  final String? username;
  final String? body;
  final String? brief;
  final String? link;
  final String? category;
  final String? communityName;
  final String? communityProfilePic;
  final String? postLength;
  final int? commentCount;
  final Timestamp postedOn;
  final String title;
  final String id;
  List<String> upVotes;
  List<String> downVotes;
  Articles({
    required this.author,
    this.bannerImage,
    this.username,
    this.body,
    this.brief,
    this.link,
    this.category,
    this.communityName,
    this.communityProfilePic,
    this.postLength,
    this.commentCount,
    required this.postedOn,
    required this.title,
    required this.id,
    required this.upVotes,
    required this.downVotes,
  });

  Articles copyWith({
    String? author,
    String? bannerImage,
    String? username,
    String? body,
    String? brief,
    String? link,
    String? category,
    String? communityName,
    String? communityProfilePic,
    String? postLength,
    int? commentCount,
    Timestamp? postedOn,
    String? title,
    String? id,
    List<String>? upVotes,
    List<String>? downVotes,
  }) {
    return Articles(
      author: author ?? this.author,
      bannerImage: bannerImage ?? this.bannerImage,
      username: username ?? this.username,
      body: body ?? this.body,
      brief: brief ?? this.brief,
      link: link ?? this.link,
      category: category ?? this.category,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      postLength: postLength ?? this.postLength,
      commentCount: commentCount ?? this.commentCount,
      postedOn: postedOn ?? this.postedOn,
      title: title ?? this.title,
      id: id ?? this.id,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'bannerImage': bannerImage,
      'username': username,
      'body': body,
      'brief': brief,
      'link': link,
      'category': category,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'postLength': postLength,
      'commentCount': commentCount,
      'postedOn': postedOn,
      'title': title,
      'id': id,
      'upVotes': upVotes,
      'downVotes': downVotes,
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      author: map['author'] as String,
      bannerImage: map['bannerImage'] as String,
      username: map['username'] as String,
      body: map['body'] as String,
      brief: map['brief'] as String,
      link: map['link'] as String,
      category: map['category'] as String,
      communityName: map['communityName'] as String,
      communityProfilePic: map['communityProfilePic'] as String,
      postLength: map['postLength'] as String,
      commentCount: map['commentCount'] as int,
      postedOn: map['postedOn'] as Timestamp,
      title: map['title'] as String,
      id: map['id'] as String,
      upVotes: List<String>.from(map['upVotes']),
      downVotes: List<String>.from(map['downVotes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Articles.fromJson(String source) =>
      Articles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Articles(author: $author, bannerImage: $bannerImage, username: $username, body: $body, brief: $brief, link: $link, category: $category, communityName: $communityName, communityProfilePic: $communityProfilePic, postLength: $postLength, commentCount: $commentCount, postedOn: $postedOn, title: $title, id: $id, upVotes: $upVotes, downVotes: $downVotes)';
  }

  @override
  bool operator ==(covariant Articles other) {
    if (identical(this, other)) return true;

    return other.author == author &&
        other.bannerImage == bannerImage &&
        other.username == username &&
        other.body == body &&
        other.brief == brief &&
        other.link == link &&
        other.category == category &&
        other.communityName == communityName &&
        other.communityProfilePic == communityProfilePic &&
        other.postLength == postLength &&
        other.commentCount == commentCount &&
        other.postedOn == postedOn &&
        other.title == title &&
        other.id == id &&
        listEquals(other.upVotes, upVotes) &&
        listEquals(other.downVotes, downVotes);
  }

  @override
  int get hashCode {
    return author.hashCode ^
        bannerImage.hashCode ^
        username.hashCode ^
        body.hashCode ^
        brief.hashCode ^
        link.hashCode ^
        category.hashCode ^
        communityName.hashCode ^
        communityProfilePic.hashCode ^
        postLength.hashCode ^
        commentCount.hashCode ^
        postedOn.hashCode ^
        title.hashCode ^
        id.hashCode ^
        upVotes.hashCode ^
        downVotes.hashCode;
  }
}
