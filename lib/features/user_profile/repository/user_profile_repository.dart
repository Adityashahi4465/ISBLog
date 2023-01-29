import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:iasblog/models/user_model.dart';

import '../../../core/constents/firebase_constents.dart';
import '../../../core/failiur.dart';
import '../../../core/providers/firebase_provider.dart';
import '../../../core/type_def.dart';
import '../../../models/articals_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.email).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Articles>> getUserArticles(String uid) {
    return _articles
        .where('author', isEqualTo: uid)
        .orderBy('postedOn', descending: true)
        .snapshots()
        .distinct()
        .map((event) => event.docs
            .map(
              (e) => Articles.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _articles =>
      _firestore.collection(FirebaseConstants.articlesCollection);
}
