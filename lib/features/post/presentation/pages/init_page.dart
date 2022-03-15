import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomwall/core/widgets/error_widget.dart' as err;
import 'package:freedomwall/core/widgets/loading_widget.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:freedomwall/features/post/presentation/pages/home_page.dart';
import 'package:freedomwall/features/post/presentation/pages/specific_post_page.dart';

class InitPage extends StatelessWidget {
  final PostEvent initialEvent;
  const InitPage({
    required this.initialEvent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostBloc>(context).add(initialEvent);
    return Center(
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          //initial state
          if (state is Initial) {
            BlocProvider.of<PostBloc>(context).add(initialEvent);
          }
          if (state is Loading) {
            return const LoadingWidget();
          } else if (state is Error) {
            return Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: err.ErrorWidget(
                message: state.message,
              ),
            );
          } else if (state is PostsLoaded) {
            return StreamBuilder<List<Post>>(
              stream: state.posts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return err.ErrorWidget(message: snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return HomePage(posts: snapshot.data!);
                  } else {
                    return const err.ErrorWidget(message: 'No Posts to show.');
                  }
                } else {
                  return err.ErrorWidget(
                      message: 'State: ${snapshot.connectionState}');
                }
              },
            );
          } else if (state is SinglePostLoaded) {
            log("state is SinglePostLoaded");
            return SpecificPostPage(post: state.post);
          } else if (state is StreamConnected) {
            // state.
            log("state is StreamConnected");
            return StreamBuilder<List<Post>>(
              stream: state.postStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return err.ErrorWidget(message: snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return HomePage(posts: snapshot.data!);
                  } else {
                    return const err.ErrorWidget(message: 'No Posts to show.');
                  }
                } else {
                  return err.ErrorWidget(
                      message: 'State: ${snapshot.connectionState}');
                }
              },
            );
          } else if (state is PostCreated) {
            return SpecificPostPage(post: state.post);
          } else {
            return const err.ErrorWidget(message: "Page Not Found");
          }
        },
      ),
    );
  }
}
