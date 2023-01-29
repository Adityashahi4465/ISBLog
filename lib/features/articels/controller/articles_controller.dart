//controller
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/features/articels/repository/articles_repository.dart';
import 'package:iasblog/features/auth/controller/auth_controller.dart';
import 'package:iasblog/models/community_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';
import '../../../models/articals_model.dart';
import '../../../models/comment_model.dart';

final articleControllerProvider =
    StateNotifierProvider<ArticleController, bool>((ref) {
  final communityRepository = ref.watch(articleRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ArticleController(
      articleRepository: communityRepository,
      storageRepository: storageRepository,
      ref: ref);
});
final userArticleProvider = StreamProvider((ref) {
  final articleController = ref.watch(articleControllerProvider.notifier);
  return articleController.fatchUserArticles();
});
final GuestArticleProvider = StreamProvider((ref) {
  final articleController = ref.watch(articleControllerProvider.notifier);
  return articleController.fatchGuestArticles();
});
// final userCommunityArticleProvider =
//     StreamProvider.family((ref, Set<Community> communities) {
//   final articleController = ref.watch(articleControllerProvider.notifier);
//   return articleController.fatchUserCommunityArticles(communities);
// });

final getArticleByIdProvider = StreamProvider.family((ref, String articleId) {
  final articleController = ref.watch(articleControllerProvider.notifier);
  return articleController.getArticleById(articleId);
});
final getArticleCommentsProvider =
    StreamProvider.family((ref, String articleId) {
  final articleController = ref.watch(articleControllerProvider.notifier);
  return articleController.fetchArticleComments(articleId);
});

class ArticleController extends StateNotifier<bool> {
  final ArticlesRepository _articleRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  ArticleController({
    required ArticlesRepository articleRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _articleRepository = articleRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareArticle({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String category,
    required String brief,
    required String description,
    required String link,
    required String readingTime,
    required File? file,
    required Uint8List? bannerWebFile,
  }) async {
    state = true; // Loading has Started
    String articleId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'articles/${selectedCommunity.name}',
      id: articleId,
      file: file,
      webFile: bannerWebFile,
    );
    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Articles post = Articles(
        author: user.email,
        postedOn: Timestamp.now(),
        title: title,
        brief: brief,
        body: description,
        id: articleId,
        upVotes: [],
        downVotes: [],
        category: category,
        commentCount: 0,
        postLength: readingTime,
        bannerImage: r,
        link: link,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        username: user.name,
      );
      final res = await _articleRepository.addArticle(post);
      state = false;
      res.fold((l) {
        showSnackBar(context, l.message);
      }, (r) {
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Articles>> fatchUserArticles() {
    return _articleRepository.fatchUserArticles();
  }

  Stream<List<Articles>> fatchGuestArticles() {
    return _articleRepository.fatchGuestArticles();
  }

  // Stream<List<Articles>> fatchUserCommunityArticles(
  //     List<Community> communities) {
  //   if (communities.isNotEmpty) {
  //     return _articleRepository.fatchUserCommunityArticles(communities);
  //   }
  //   return Stream.value([]);
  // }
// Stream<Set<Articles>> fatchUserCommunityArticles(Set<Community> communities) {
//     return _articleRepository.fatchUserCommunityArticles(communities)
//         .map((list) => Set.from(list));
//   }
  Stream<Articles> getArticleById(String articleId) {
    return _articleRepository.getArticleById(articleId);
  }

  void deleteArticle(Articles article, BuildContext context) async {
    final res = await _articleRepository.deleteArticle(article);
    res.fold((l) => null,
        (r) => showSnackBar(context, 'Article Deleted Successfully!'));
  }

  void upVote(Articles articles) async {
    final uid = _ref.read(userProvider)!.email;
    _articleRepository.upVote(articles, uid);
  }

  void downVote(Articles articles) async {
    final uid = _ref.read(userProvider)!.email;
    _articleRepository.downVote(articles, uid);
  }

  void addComment(
      {required BuildContext context,
      required String text,
      required Articles article}) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();

    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      articleId: article.id,
      username: user.name,
      profilePic: user.profilePic,
    );
    final res = await _articleRepository.addComment(comment);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Comment added successfully!'));
  }

  Stream<List<Comment>> fetchArticleComments(String articleId) {
    return _articleRepository.getCommentsOfArticle(articleId);
  }
}
