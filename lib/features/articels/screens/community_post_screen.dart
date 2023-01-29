// post screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/features/articels/controller/articles_controller.dart';
import 'package:iasblog/features/community/controller/commnuity_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../widgets/card.dart';

class CommunityFeedScreen extends ConsumerWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold();
    // return ref.watch(userCommunitiesProvider).when(
    //       data: (community) =>
    //           ref.watch(userCommunityArticleProvider(community)).when(
    //                 data: (data) {
    //                   return ListView.builder(
    //                     physics:
    //                         const ClampingScrollPhysics(), // By Using this List Become Scrollable
    //                     controller: ScrollController(initialScrollOffset: 0),
    //                     shrinkWrap: true,
    //                     itemCount: data.length,
    //                     itemBuilder: (BuildContext context, int index) {
    //                       final articles = data[index];
    //                       return PostOverviewCard(
    //                         articles: articles,
    //                       );
    //                     },
    //                   );
    //                 },
    //                 error: (error, stackTrace) => ErrorText(
    //                   error: error.toString(),
    //                 ),
    //                 loading: () => const Loader(),
    //               ),
    //       error: (error, stackTrace) => ErrorText(
    //         error: error.toString(),
    //       ),
    //       loading: () => const Loader(),
    //     );
  }
}
