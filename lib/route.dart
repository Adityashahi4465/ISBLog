// loggedOut route
// loggedIn route

import 'package:flutter/material.dart';
import 'package:iasblog/features/articels/screens/comment_screen.dart';
import 'package:iasblog/features/community/screens/add_mod_screen.dart';
import 'package:iasblog/features/community/screens/create_community_screen.dart';
import 'package:iasblog/features/community/screens/edit_community_screen.dart';
import 'package:iasblog/features/home/screens/home_Screen.dart';
import 'package:iasblog/features/community/screens/mod_tools_screen.dart';
import 'package:iasblog/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'features/articels/screens/add_article_screen.dart';
import 'features/articels/screens/article_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/community/screens/community_screen.dart';
import 'features/user_profile/screens/edit_user_profile_screen.dart';

final loggedOutRouter = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});
final loggedInRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomePage(),
        ),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),

    '/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ), // dynamic
    '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/u/:uid': (routeData) => MaterialPage(
          child: UserProfile(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/article/:articleId': (routeData) => MaterialPage(
          child: ArticleScreen(
            articleId: routeData.pathParameters['articleId']!,
          ),
        ),
    '/article/:articleId/comments': (routeData) => MaterialPage(
          child: CommentScreen(
            articleId: routeData.pathParameters['articleId']!,
          ),
        ),
    '/add-article/': (routeData) => const MaterialPage(
          child: AddArticleTypeScreen(),
        ),
    // route specially for web
  },
);
