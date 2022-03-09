part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends PostEvent {
  final String? creator;
  final String? title;

  const GetPostsEvent({
    this.creator,
    this.title,
  });

  @override
  List<Object> get props {
    if (creator != null) {
      super.props.add(creator!);
    } else if (title != null) {
      super.props.add(creator!);
    }
    return super.props;
  }
}

class StreamPostsEvent extends PostEvent{
  const StreamPostsEvent();
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
