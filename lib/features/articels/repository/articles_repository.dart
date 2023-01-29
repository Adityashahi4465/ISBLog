// repository
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:iasblog/core/constents/firebase_constents.dart';
import 'package:iasblog/core/providers/firebase_provider.dart';

import 'package:iasblog/models/articals_model.dart';

import '../../../core/failiur.dart';
import '../../../core/type_def.dart';
import '../../../models/comment_model.dart';

final articleRepositoryProvider = Provider((ref) {
  return ArticlesRepository(firestore: ref.watch(firestoreProvider));
});

class ArticlesRepository {
  final FirebaseFirestore _firestore;
  ArticlesRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _articles =>
      _firestore.collection(FirebaseConstants.articlesCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);

  FutureVoid addArticle(Articles article) async {
    try {
      return right(_articles.doc(article.id).set(article.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Articles>> fatchUserArticles() {
    return _articles.orderBy('postedOn', descending: true).snapshots().map(
        (event) => event.docs
            .map((e) => Articles.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
  Stream<List<Articles>> fatchGuestArticles() {
    return _articles.orderBy('postedOn', descending: true).limit(30).snapshots().map(
        (event) => event.docs
            .map((e) => Articles.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  // Stream<List<Articles>> fatchUserCommunityArticles(
  //     List<Community> communities) {
  //   return _articles
  //       .where('communityName',
  //           whereIn: communities.map((e) => e.name).toList())
  //       .orderBy('postedOn', descending: true)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map(
  //             (e) => Articles.fromMap(e.data() as Map<String, dynamic>),
  //           )
  //           .toList());
  // }

  Stream<Articles> getArticleById(String articleId) {
    return _articles
        .doc(articleId)
        .snapshots()
        .map((event) => Articles.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid deleteArticle(Articles article) async {
    try {
      return right(_articles.doc(article.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upVote(Articles articles, String userId) async {
    if (articles.downVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (articles.upVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _articles.doc(articles.id).update({
        'upVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downVote(Articles articles, String userId) async {
    if (articles.upVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (articles.downVotes.contains(userId)) {
      _articles.doc(articles.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _articles.doc(articles.id).update({
        'downVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(_articles.doc(comment.articleId).update({
        'commentCount': FieldValue.increment(1),
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfArticle(String articleId) {
    return _comments
        .where('articleId', isEqualTo: articleId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Comment.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }
}
