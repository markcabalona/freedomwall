import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required id,
    required postId,
    required creator,
    required content,
    required dateCreated,
    required likes,
    required dislikes,
  }) : super(
          id: id,
          postId: postId,
          creator: creator,
          content: content,
          dateCreated: dateCreated,
          likes: likes,
          dislikes: dislikes,
        );

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"] as int,
        postId: json["post_id"] as int,
        creator: json["creator"],
        content: json["content"],
        dateCreated: DateTime.parse(json["date_created"] as String),
        likes: json["likes"] as int,
        dislikes: json["dislikes"] as int,
      );
}

class CommentCreateModel extends CreateModel {
  final int postId;
  const CommentCreateModel({
    required this.postId,
    required String creator,
    required String content,
  }) : super(content: content, creator: creator);

  @override
  Map<String, dynamic> get toJson => {
        "post_id": postId,
        "creator": creator,
        "content": content,
      };
}
