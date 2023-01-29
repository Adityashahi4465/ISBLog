import 'package:iasblog/theme/pallet.dart';
import 'package:intl/intl.dart';

/// Import this line
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/features/articels/controller/articles_controller.dart';
import 'package:iasblog/features/auth/controller/auth_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class ArticleScreen extends ConsumerStatefulWidget {
  final String? articleId;
  const ArticleScreen({required this.articleId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends ConsumerState<ArticleScreen> {
  // final commentController = TextEditingController();

  // @override
  // void dispose() {
  //   super.dispose();
  //   commentController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getArticleByIdProvider(widget.articleId!)).when(
          data: (article) {
            return ref
                .watch(getUserDataProvider(article.author.toString()))
                .when(
                  data: (user) {
                    print('article Screen is calling in user ref');
                    return Scaffold(
                      body: CustomScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        controller: ScrollController(initialScrollOffset: 0),
                        shrinkWrap: true,
                        slivers: [
                          SliverAppBar(
                            // actions: [
                            //   IconButton(
                            //     onPressed: () {
                            //       showSearch(
                            //         context: context,
                            //         delegate: SearchCommunityDelegate(ref),
                            //       );
                            //     },
                            //     icon: const Icon(Icons.search),
                            //   ),
                            //   IconButton(
                            //     onPressed: () {
                            //       Routemaster.of(context).push('/add-post');
                            //     },
                            //     icon: const Icon(Icons.add),
                            //   ),
                            //   Builder(builder: (context) {
                            //     return IconButton(
                            //       icon: CircleAvatar(
                            //         backgroundImage: NetworkImage(user.profilePic),
                            //       ),
                            //       iconSize: 50,
                            //       onPressed: () {
                            //         displayEndDrawer(context);
                            //       },
                            //     );
                            //   }),
                            // ],
                            toolbarHeight: 80,
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(25),
                              child: Container(
                                width: double.maxFinite,
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9333EA),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: SelectableText(
                                    article.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            pinned: true,
                            backgroundColor: const Color(0xFFC026D3),
                            expandedHeight: 300,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Image.network(
                                article.bannerImage.toString(),
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/images/js.jpg'),
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.profilePic),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat('MMM dd, yyyy').format(
                                                article.postedOn.toDate()),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${article.postLength.toString()}min read',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.greenAccent[400],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide.none)),
                                    icon: const Icon(Icons.person_add),
                                    onPressed: () {},
                                    label: const Text('Follow'),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              height: 200,
                              width: 200,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Color(0xFFBEBEBE),
                                      offset: Offset(10, 10),
                                      blurRadius: 30,
                                      spreadRadius: 1,
                                    ),
                                    const BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(-10, -10),
                                      blurRadius: 30,
                                      spreadRadius: 1,
                                    ),
                                  ]),
                              child: Center(
                                child: Text(
                                  article.brief.toString(),
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8).copyWith(top: 20),
                              child: Text(
                                article.body.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(left: 6, right: 6),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) {
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
