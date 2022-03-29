import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/core/utils/input_converter.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/usecases/create_content.dart';
import 'package:freedomwall/features/post/domain/usecases/get_post_by_id.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';
import 'package:freedomwall/features/post/domain/usecases/stream_post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final StreamPosts streamPosts;
  final GetPostById getPostById;
  final CreateContent createContent;
  final LikeDislikeContent likeDislikeContent;
  final InputConverter inputConverter;

  PostBloc({
    required this.streamPosts,
    required this.createContent,
    required this.likeDislikeContent,
    required this.getPostById,
    required this.inputConverter,
  }) : super(const Loading()) {
    on<StreamPostsEvent>((event, emit) async {
      emit(const Loading());

      final _post = await streamPosts(event.params);

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
        return;
      });
    });

    on<GetPostsEvent>((event, emit) async {
      emit(const Loading());

      final post = await streamPosts(event.params);

      post.fold((failure) {
        emit(Error(message: failure.message));
      }, (posts) {
        emit(PostsLoaded(posts: posts));
      });
    });

    on<GetPostByIdEvent>((event, emit) async {
      emit(const Loading());

      final post = await getPostById(event.postId);

      post.fold(
        (failure) {
          emit(Error(message: failure.message));
        },
        (post) {
          emit(SinglePostLoaded(post: post));
        },
      );
    });

    on<LikeDislikePostEvent>((event, emit) async {
      final post = await likeDislikeContent(event.params);

      if (post.isLeft()) post.leftMap((l) => emit(Error(message: l.message)));
    });
  }
}
