import 'package:flutter/material.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/core/post/post_widget.dart';
import 'package:freedomwall/features/post/presentation/widgets/core/create_post_dialog.dart';
import 'package:freedomwall/features/post/presentation/widgets/mobile/post_search_bar_mobile.dart';

import 'package:freedomwall/features/post/presentation/widgets/web/post_searchbar_widget.dart';

class SpecificPostPage extends StatelessWidget {
  final Post post;
  const SpecificPostPage({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: _width * .025),
              child: PostWidget(
                post: post,
                isExpanded: true,
                width: 800,
              ),
            ),
          ),
        ));
  }
}
