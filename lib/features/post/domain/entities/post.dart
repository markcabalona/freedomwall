import 'package:freedomwall/core/domain/entities/content.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';

class Post extends Content {
  final String title;
  final List<Comment> comments;

  const Post(
      {id,
      required creator,
      required this.title,
      required content,
      dateCreated,
      likes,
      dislikes,
      required this.comments})
      : super(
          id: id,
          creator: creator,
          content: content,
          dateCreated: dateCreated,
          likes: likes,
          dislikes: dislikes,
        );

  @override
  List<Object?> get props => super.props + [title, comments];
}
