import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/homepage/post_widget.dart';

class HomePage extends StatelessWidget {
  final List<Post> posts;
  const HomePage({
    required this.posts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // extendBody: true,
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () {
            Navigator.restorablePopAndPushNamed(context, '/');
          },
          child: const Text("FreedomWall"),
        ),
      ),
      body: MasonryGridView.builder(
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          padding: const EdgeInsets.only(
              top: kToolbarHeight, bottom: 20, left: 100, right: 100),
          gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 600,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostWidget(
              post: posts[index],
            );
          }),
    );
  }
}
