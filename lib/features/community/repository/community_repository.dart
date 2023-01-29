import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:iasblog/core/constents/firebase_constents.dart';
import 'package:iasblog/core/failiur.dart';
import 'package:iasblog/core/providers/firebase_provider.dart';
import 'package:iasblog/models/community_model.dart';

import '../../../core/type_def.dart';
import '../../../models/articals_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw ' Community with the same name already exists!';
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayUnion([
          userId
        ]), // FieldValue function to add elements to existing list in firebase
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayRemove(
          [userId],
        ), // FieldValue function to add elements to existing list in firebase
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .distinct()
        .map(
      (event) {
        List<Community> communities = [];
        for (var doc in event.docs) {
          communities
              .add(Community.fromMap(doc.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().distinct().map(
          (event) => Community.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities //   Search Algorithm
        .where(
          'name',
          isGreaterThanOrEqualTo:
              query.isEmpty ? 0 : query, // no suggetions if query is 0
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .distinct()
        .map((event) {
      List<Community> communities = [];
      for (var community in event.docs) {
        communities
            .add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({
        'mods': uids,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Articles>> getCommunityArticles(String uid) {
    var f = _articles
        .where('communityName', isEqualTo: uid)
        .orderBy('postedOn', descending: true)
        .snapshots()
        .distinct()
        .map((event) => event.docs
            .map(
              (e) => Articles.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
    print('getCommunityArticles fatching data');
    return f;
  }

  // Future<List<Articles>> getCommunityArticles(String uid) {
  //   var future = _articles
  //       .where('communityName', isEqualTo: uid)
  //       .orderBy('postedOn', descending: true)
  //       .get()
  //       .then((event) => event.docs
  //           .map(
  //             (e) => Articles.fromMap(e.data() as Map<String, dynamic>),
  //           )
  //           .toList());
  //   print('getCommunityArticles fatching data');
  //   return future;
  // }

  CollectionReference get _articles =>
      _firestore.collection(FirebaseConstants.articlesCollection);

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communityCollection);
}
