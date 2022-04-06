
import 'package:flutter/material.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';

class PostSearchBarMobile extends StatefulWidget {
  const PostSearchBarMobile({Key? key}) : super(key: key);

  @override
  State<PostSearchBarMobile> createState() => _PostSearchBarMobileState();
}

class _PostSearchBarMobileState extends State<PostSearchBarMobile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () {
          showSearch(
            context: context,
            delegate: CustomSearch(posts: []),
          );
        },
        icon: const Icon(Icons.search),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  final List<Post> posts;


  CustomSearch({required this.posts});
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      const Text("Actions")
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading

    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return query.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              posts.map(((post) {
                if (post.title.contains(query)) {
                  return ListTile(
                    title: Text(post.title),
                  );
                }
              }));
              return const SizedBox();
            },
          )
        : const SizedBox();
  }
}
