import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/core/common/error_text.dart';
import 'package:iasblog/core/common/loader.dart';
import 'package:iasblog/features/auth/controller/auth_controller.dart';
import 'package:iasblog/features/community/controller/commnuity_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/community_model.dart';
import '../../../widgets/card.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModeTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset('assets/images/js.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              // onForegroundImageError: (exception, stackTrace) =>
                              //     const Loader(),
                              onBackgroundImageError: (exception, stackTrace) =>
                                  Image.asset(
                                    'assets/images/logo.jpg',
                                    fit: BoxFit.cover,
                                  ),
                              radius: 35),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              community.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            if (!isGuest)
                              community.mods.contains(user.email)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        navigateToModeTools(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: const Text('Mod Tools'),
                                    )
                                  : OutlinedButton(
                                      onPressed: () => joinCommunity(
                                          ref, community, context),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25)),
                                      child: Text(
                                          community.members.contains(user.email)
                                              ? 'Joined'
                                              : 'Join'),
                                    )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '${community.members.length} members',
                          ),
                        ),
                      ]),
                    ),
                  )
                ];
              },
              body: ref.watch(getCommunityArticleProvider(name)).when(
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
                  error: (error, stackTrace) {
                    return ErrorText(error: error.toString());
                  },
                  // ErrorText(error: error.toString()),
                  loading: () => const Loader()),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
