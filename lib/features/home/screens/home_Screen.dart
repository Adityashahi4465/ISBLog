// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/features/home/drawer/community_drawer.dart';
import 'package:iasblog/features/home/drawer/profile_drawer.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constents/constents.dart';
import '../../../responsive/responsive.dart';
import '../../../theme/pallet.dart';
import '../../auth/controller/auth_controller.dart';
import '../delegates/search_community_delegate.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanges(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigateToType(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/add-article/');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Responsive(
      child: Scaffold(
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          controller: ScrollController(initialScrollOffset: 0),
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchCommunityDelegate(ref),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                Builder(builder: (context) {
                  return IconButton(
                    icon: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      onBackgroundImageError: (exception, stackTrace) =>
                          Image.asset('assets/images/js.jpg'),
                    ),
                    iconSize: 50,
                    onPressed: () {
                      displayEndDrawer(context);
                    },
                  );
                }),
              ],
              toolbarHeight: 80,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(25),
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  decoration: const BoxDecoration(
                    color: Pallete.pink,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: SelectableText(
                      'Read Write and Grow',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              pinned: true,
              backgroundColor: Pallete.purpleBgColor,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset('assets/images/js.jpg')),
            ),
            SliverToBoxAdapter(
              child: Constants.tabWidgets[_page],
            )
          ],
        ),
        floatingActionButton: isGuest
            ? null
            : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  animationDuration: const Duration(seconds: 1),
                  backgroundColor: Pallete.pink,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Write'),
                onPressed: () => navigateToType(context),
              ),
        drawer: const HomeDrawer(),
        endDrawer: isGuest ? null : const ProfileDrawer(),
        bottomNavigationBar: isGuest
            ? null
            : CupertinoTabBar(
                activeColor: currentTheme.iconTheme.color,
                backgroundColor: currentTheme.backgroundColor,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.feed_outlined),
                    label: 'All Articles',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.compare_rounded),
                    label: 'Community Articles',
                  ),
                ],
                onTap: onPageChanges,
                currentIndex: _page,
              ),
      ),
    );
  }
}
