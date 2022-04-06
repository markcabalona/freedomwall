import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freedomwall/core/widgets/error_widget.dart' as err;

import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/core/post/post_widget.dart';
import 'package:freedomwall/features/post/presentation/widgets/core/create_post_dialog.dart';
import 'package:freedomwall/features/post/presentation/widgets/mobile/post_search_bar_mobile.dart';

import 'package:freedomwall/features/post/presentation/widgets/web/post_searchbar_widget.dart';

class HomePage extends StatelessWidget {
  final List<Post> posts;
  const HomePage({
    required this.posts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return CreatePostDialog();
            },
          );
        },
        child: const Icon(
          Icons.add_comment,
        ),
      ),
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () {
            Navigator.restorablePopAndPushNamed(context, '/');
          },
          child: const Text(
            "FreedomWall",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          _width > 600 ? const PostSearchBarWidget() : const PostSearchBarMobile(),
        ],
      ),
      body: posts.isEmpty
          ? const err.ErrorWidget(message: "No posts to show")
          : MasonryGridView.builder(
              physics: const BouncingScrollPhysics(),
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: _width * .025,
              ),
              gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: _width < 1000 ? 600 : 400,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostWidget(
                  post: posts[index],
                  width: 600,
                );
              }),
    );
  }
}
