import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_widget.dart';
import 'package:freedomwall/features/post/presentation/widgets/post_searchbar_widget.dart';

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
      // extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
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
        actions: const [
          PostSearchBarWidget(),
        ],
      ),
      body: MasonryGridView.builder(
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          // cacheExtent: 10,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 80,
          ),
          gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: _width < 1000 ? 600 : 400,
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

