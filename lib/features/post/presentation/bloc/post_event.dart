part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends PostEvent {
  final Params params;
  const GetPostsEvent({required this.params});

  @override
  List<Object> get props => super.props + [params];
}

class StreamPostsEvent extends PostEvent {
  final Params params;
  const StreamPostsEvent({required this.params});

  @override
  List<Object> get props => super.props + [params];
}

class GetPostByIdEvent extends PostEvent {
  final String postId;

  const GetPostByIdEvent({required this.postId});

  @override
  List<Object> get props => super.props + [postId];
}

class CreateContentEvent extends PostEvent {
  final CreateModel content;
  const CreateContentEvent({required this.content});

  @override
  List<Object> get props => super.props + [content];
}

class LikeDislikePostEvent extends PostEvent {
  final PostActionsParams params;
  const LikeDislikePostEvent({required this.params});

  @override
  List<Object> get props => super.props + [params];
}
