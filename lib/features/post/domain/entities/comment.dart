import 'package:freedomwall/core/domain/entities/content.dart';

class Comment extends Content {
  final String postId;

  const Comment({
    required id,
    required this.postId,
    required creator,
    required content,
    required dateCreated,
    required likes,
    required dislikes,
  }) : super(
          id: id,
          creator: creator,
          content: content,
          dateCreated: dateCreated,
          likes: likes,
          dislikes: dislikes,
        );

  @override
  List<Object?> get props => super.props + [postId];
}
