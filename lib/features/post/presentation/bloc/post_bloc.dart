import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freedomwall/core/utils/input_converter.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/usecases/create_content.dart';
import 'package:freedomwall/features/post/domain/usecases/get_posts.dart';
import 'package:freedomwall/features/post/domain/usecases/get_post_by_id.dart';
import 'package:freedomwall/features/post/domain/usecases/stream_post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final StreamPosts streamPosts;
  final GetPosts getPosts;
  final GetPostById getPostById;
  final CreateContent createContent;
  final InputConverter inputConverter;

  PostBloc({
    required this.streamPosts,
    required this.createContent,
    required this.getPosts,
    required this.getPostById,
    required this.inputConverter,
  }) : super(const Initial()) {
    on<StreamPostsEvent>((event, emit) async {
      emit(const Loading());

      final _post = await streamPosts(null);

      _post.fold((failure) {
        emit(Error(message: failure.message));
      }, (posts) {
        emit(StreamConnected(postStream: posts));
      });
    });

    on<CreateContentEvent>((event, emit) async {
      if (event.content is PostModel) {
        emit(const Loading());
      }

      final post = await createContent(event.content);

      post.fold((failure) {
        emit(Error(message: failure.message));
      }, (post) {
        if (post is Post) {
          emit(PostCreated(post: post));
        }
      });
    });

    on<GetPostsEvent>((event, emit) async {
      emit(const Loading());

      final post =
          await getPosts(Params(creator: event.creator, title: event.title));

      post.fold((failure) {
        emit(Error(message: failure.message));
      }, (posts) {
        emit(PostsLoaded(posts: posts));
      });
    });

    on<GetPostByIdEvent>((event, emit) async {
      emit(const Loading());

      final inputEither = inputConverter.stringToInt(event.postId);

      await inputEither.fold(
        (failure) {
          log(failure.message);
          emit(Error(message: "Post with id ${event.postId} not found."));
        },
        (integer) async {
          final post = await getPostById(integer);

          post.fold(
            (failure) {
              emit(Error(message: failure.message));
            },
            (post) {
              emit(SinglePostLoaded(post: post));
            },
          );
        },
      );
    });
  }
}
