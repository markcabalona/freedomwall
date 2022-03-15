part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class Initial extends PostState {
  const Initial();
}

class Loading extends PostState {
  const Loading();
}

class SinglePostLoaded extends PostState {
  final Post post;

  const SinglePostLoaded({required this.post});

  @override
  List<Object> get props => super.props + [post];
}

class PostsLoaded extends PostState {
  final List<Post> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => super.props + [posts];
}

class StreamConnected extends PostState {
  final Stream<List<Post>> postStream;

  const StreamConnected({required this.postStream});
  @override
  List<Object> get props => super.props + [postStream];
}

class PostCreated extends PostState {
  final Post post;

  const PostCreated({required this.post});

  @override
  List<Object> get props => super.props + [post];
}

class Error extends PostState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => super.props + [message];
}
