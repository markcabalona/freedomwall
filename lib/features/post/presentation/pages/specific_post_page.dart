import 'package:flutter/material.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_widget.dart';
import 'package:freedomwall/features/post/presentation/widgets/post_searchbar_widget.dart';

class SpecificPostPage extends StatelessWidget {
  final Post post;
  const SpecificPostPage({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
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
          actions: const [
            PostSearchBarWidget(),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: kToolbarHeight, horizontal: 80),
              child: PostWidget(
                post: post,
                isExpanded: true,
                width: 600,
              ),
            ),
          ),
        ));
  }
}
