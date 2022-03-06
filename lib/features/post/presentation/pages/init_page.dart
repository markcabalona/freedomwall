import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomwall/core/widgets/error_widget.dart' as err;
import 'package:freedomwall/core/widgets/loading_widget.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:freedomwall/features/post/presentation/pages/home_page.dart';
import 'package:freedomwall/features/post/presentation/pages/specific_post_page.dart';
import 'package:freedomwall/injection_container.dart';

class InitPage extends StatelessWidget {
  final Either<StreamPostsEvent, GetPostByIdEvent> initialEvent;
  const InitPage({
    required this.initialEvent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocProvider<PostBloc>(
        create: (context) => sl<PostBloc>(),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            //initial state
            if (state is Initial) {
              BlocProvider.of<PostBloc>(context).add(
                initialEvent.fold(
                  (streamPostsEvent) => streamPostsEvent,
                  (getPostByIdEvent) => getPostByIdEvent,
                ),
              );
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
            } else if (state is Loaded) {
              if (state.posts.isEmpty) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: const err.ErrorWidget(
                    message: "No Posts to show",
                  ),
                );
              }
              return SpecificPostPage(
                post: state.posts[0],
              );
            } else if (state is StreamConnected) {
              // state.
              return HomePage(posts: state.postStream);
            } else {
              return const err.ErrorWidget(message: "Page Not Found");
            }
          },
        ),
      ),
    );
  }
}
