import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/features/community/controller/commnuity_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../widgets/card.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/articles_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("feed screens build method called");
    final user = ref.read(userProvider)!;
    final isGuest = !user.isAuthenticated;
    if (!isGuest) {
      return ref.watch(userArticleProvider).when(
            data: (data) {
              return ListView.builder(
                physics:
                    const ClampingScrollPhysics(), // By Using this List Become Scrollable
                controller: ScrollController(initialScrollOffset: 0),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final articles = data[index];
                  return PostOverviewCard(
                    articles: articles,
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    } else {
      return ref.watch(GuestArticleProvider).when(
            data: (data) {
              return ListView.builder(
                physics:
                    const ClampingScrollPhysics(), // By Using this List Become Scrollable
                controller: ScrollController(initialScrollOffset: 0),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final articles = data[index];
                  return PostOverviewCard(
                    articles: articles,
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          );
    }
  }
}
