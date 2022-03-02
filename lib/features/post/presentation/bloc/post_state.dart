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

class Loaded extends PostState {
  final List<Post> posts;

  const Loaded({required this.posts});

  @override
  List<Object> get props => super.props + [posts];
}

class StreamConnected extends PostState {
  final _postStreamController = BehaviorSubject<List<Post>>.seeded(const []);

  // final Stream<List<Post>> _postStream;
  Stream<List<Post>> get postStream =>
      _postStreamController.asBroadcastStream();

  StreamConnected({required postStream}) {
    _postStreamController.addStream(postStream);
  }
}

class PostCreated extends PostState {
  const PostCreated();
}

class Error extends PostState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => super.props + [message];
}
