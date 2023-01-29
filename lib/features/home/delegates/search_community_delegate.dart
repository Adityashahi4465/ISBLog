import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iasblog/core/common/error_text.dart';
import 'package:iasblog/core/common/loader.dart';
import 'package:iasblog/features/community/controller/commnuity_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(
          Icons.close,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
        data: (communities) => ListView.builder(
            itemCount: communities.length,
            itemBuilder: (BuildContext context, int index) {
              final community = communities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text(community.name),
                onTap: () => navigateToCommunity(context, community.name),
              );
            }),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/$communityName');
  }
}
