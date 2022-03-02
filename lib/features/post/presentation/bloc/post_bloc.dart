import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freedomwall/core/utils/input_converter.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/usecases/create_post.dart';
import 'package:freedomwall/features/post/domain/usecases/get_posts.dart';
import 'package:freedomwall/features/post/domain/usecases/get_post_by_id.dart';
import 'package:freedomwall/features/post/domain/usecases/stream_post.dart';
import 'package:rxdart/rxdart.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final StreamPosts streamPosts;
  final GetPosts getPosts;
  final GetPostById getPostById;
  final CreatePost createPost;
  final InputConverter inputConverter;

  PostBloc({
    required this.streamPosts,
    required this.createPost,
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

    on<CreatePostEvent>((event, emit) async {
      emit(const Loading());

      final post = await createPost(event.post);

      post.fold((failure) {
        emit(Error(message: failure.message));
      }, (_) {
        emit(const PostCreated());
      });
    });

    on<GetPostsEvent>((event, emit) async {
      emit(const Loading());

      final post =
          await getPosts(Params(creator: event.creator, title: event.title));

      post.fold((failure) {
        emit(Error(message: failure.message));
      }, (posts) {
        emit(Loaded(posts: posts));
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
              emit(Loaded(posts: [post]));
            },
          );
        },
      );
    });
  }
}
