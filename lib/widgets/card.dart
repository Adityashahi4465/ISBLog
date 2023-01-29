import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/features/articels/controller/articles_controller.dart';
import 'package:iasblog/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';

import '../core/common/error_text.dart';
import '../core/common/loader.dart';
import '../features/auth/controller/auth_controller.dart';
import '../features/community/controller/commnuity_controller.dart';
import '../models/articals_model.dart';
import '../responsive/responsive.dart';

// ignore: must_be_immutable
class PostOverviewCard extends ConsumerStatefulWidget {
  Articles articles;
  PostOverviewCard({super.key, required this.articles});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostOverviewCardState();
}

class _PostOverviewCardState extends ConsumerState<PostOverviewCard> {
  void navigateToArticle(BuildContext context) {
    Routemaster.of(context).push('/article/${widget.articles.id}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/article/${widget.articles.id}/comments');
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${widget.articles.author}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/${widget.articles.communityName}');
  }

  void deleteArticle(WidgetRef ref, BuildContext context) async {
    ref
        .read(articleControllerProvider.notifier)
        .deleteArticle(widget.articles, context);
  }

  void upVote(WidgetRef ref, BuildContext context) async {
    ref.read(articleControllerProvider.notifier).upVote(widget.articles);
  }

  void downVote(WidgetRef ref, BuildContext context) async {
    ref.read(articleControllerProvider.notifier).downVote(widget.articles);
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final currentUser = ref.watch(userProvider)!;
    final isGuest = !currentUser.isAuthenticated;

    print('Card Build Method called');
    return ref.watch(getUserDataProvider(widget.articles.author)).when(
          data: (user) {
            return Responsive(
              child: Card(
                color: currentTheme.drawerTheme.backgroundColor,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                elevation: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          height: 240,
                          onImageError: (exception, stackTrace) => Image.asset(
                            'assets/images/js.jpg',
                            fit: BoxFit.cover,
                            height: 240,
                          ),
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.articles.bannerImage.toString(),
                          ),
                          child: InkWell(
                            onTap: () => navigateToArticle(context),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 16,
                        //   right: 16,
                        //   left: 16,
                        //   child:
                        // )
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 10, top: 3),
                      child: Text(
                        widget.articles.title.toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0)
                          .copyWith(bottom: 0, top: 5),
                      child: SelectableText(
                        widget.articles.brief.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: GestureDetector(
                                onTap: () => navigateToUserProfile(context),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.profilePic),
                                  foregroundImage:
                                      NetworkImage(user.profilePic),
                                  backgroundColor: Colors.deepPurple,
                                  radius: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                user.name.toString().length > 10
                                    ? user.name.substring(0, 10)
                                    : user.name,
                                // widget.widget.articles.author!,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pinkAccent[400]),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.20,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: Center(
                                  child: Text(
                                    widget.articles.category.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.share,
                                color: currentTheme.iconTheme.color,
                                size: MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    isGuest ? () {} : upVote(ref, context),
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: widget.articles.upVotes
                                          .contains(currentUser.email)
                                      ? Pallete.redColor
                                      : currentTheme.iconTheme.color,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                              ),
                              Text(
                                '${widget.articles.upVotes.length - widget.articles.downVotes.length == 0 ? 'Vote' : widget.articles.upVotes.length - widget.articles.downVotes.length}',
                              ),
                              IconButton(
                                onPressed: () =>
                                    isGuest ? () {} : downVote(ref, context),
                                icon: Icon(
                                  Icons.thumb_down,
                                  color: widget.articles.downVotes
                                          .contains(currentUser.email)
                                      ? Pallete.redColor
                                      : currentTheme.iconTheme.color,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                              ),
                              IconButton(
                                onPressed: () => navigateToComments(context),
                                icon: Icon(
                                  Icons.comment,
                                  color: currentTheme.iconTheme.color,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                              ),
                              Text(
                                '${widget.articles.commentCount == 0 ? 'Comment' : widget.articles.commentCount}',
                              ),
                            ],
                          ),
                          ref
                              .watch(getCommunityByNameProvider(
                                  widget.articles.communityName.toString()))
                              .when(
                                  data: (data) {
                                    if (data.mods.contains(user.email)) {
                                      return IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.admin_panel_settings,
                                          color: currentTheme.iconTheme.color,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.08,
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                  error: (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                                  loading: () => const Loader()),
                          if (widget.articles.author == currentUser.email)
                            IconButton(
                              onPressed: () => deleteArticle(ref, context),
                              icon: Icon(
                                Icons.delete,
                                color: Pallete.redColor,
                                size: MediaQuery.of(context).size.width * 0.08,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
