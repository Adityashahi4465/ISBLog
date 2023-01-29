import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iasblog/core/constents/constents.dart';
import 'package:iasblog/core/constents/firebase_constents.dart';
import 'package:iasblog/core/failiur.dart';
import 'package:iasblog/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/firebase_provider.dart';
import '../../../core/type_def.dart';
// this is completely for my database calls

final authRepositoryProvider = Provider((ref) => AuthRepository(
    // Now we are using provider for firebase instance as well insted of creating like FirebaseFirestore.instance
    // How I am going to use Firebase provers into this provider?, that is that **ref** is for
    // ref allows us to talk with other providers. IT provides us many methods ref.Read() & ref.Watch most is most important
    // ref.read is usually used out side of build Context means you don't want to read any changes mad in providers
    firestore: ref.read(
        firestoreProvider), //It gives the instance if firebaseFirestore class
    auth: ref.read(
        authProvider), // It all provers coming from firebase_providers.dart
    googleSignIn: ref.read(googleSignInProvider)));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      // Since variables are private we can't access it by using this. keyword  insted of that we are creating an instance of it and assigning to the private variables
      {required FirebaseAuth auth,
      required FirebaseFirestore firestore,
      required GoogleSignIn googleSignIn})
      : _auth = auth, // assigning to private variables
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  // Creating a getter to save the data to firebase
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      //We are handling errors here but we going to throw them in controller part later on
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        // Now create the user credential and store into firebase console
        if (isFromLogin) {
          userCredential = await _auth.signInWithCredential(credential);
        } else {
          userCredential =
              await _auth.currentUser!.linkWithCredential(credential);
        }
      }

      UserModel userModel;
      // _firestore.collection('User').doc(userCredential.user!.email).set({''})  // We not going to store data like this insted we will create a User model means how the user will look like
      // if (userCredential.additionalUserInfo!.isNewUser) {
      // If User is Logging for first time
      userModel = UserModel(
        name: userCredential.user!.displayName ?? ' No Name',
        email: userCredential.user!.email ?? 'Email not Available',
        profilePic: userCredential.user!.photoURL ?? 'assets/images/logo.jpg',
        profile_banner: '',
        isAuthenticated: true,
        followerCount: [],
        posts: [],
      );
      await _users.doc(userCredential.user!.email).set(userModel.toMap());
      // } else {
      //   // If user already logged In logging In second time
      //   userModel =
      //       await getUserData(userCredential.user!.uid.toString()).first;
      // }
      // _firestore.collection('User')
      return right(userModel); // Passing success  and userModel
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      // If any error occur din above code
      // ScaffoldMessenger(child: ,) // for this I need context and I don;t want to use context in this class for this we have authController class
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();
      UserModel userModel = const UserModel(
        name: 'Guest',
        email: 'Email not Available',
        profilePic: 'assets/images/logo.jpg',
        profile_banner: Constants.bannerDefault,
        isAuthenticated: false,
        followerCount: [],
        posts: [],
      );
      await _users.doc(userCredential.user!.email).set(userModel.toMap());

      return right(userModel); // Passing success  and userModel
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      // If any error occur din above code
      // ScaffoldMessenger(child: ,) // for this I need context and I don;t want to use context in this class for this we have authController class
      return left(Failure(e.toString()));
    }
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().distinct().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
