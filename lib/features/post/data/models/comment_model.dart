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

  Map<String, dynamic> get toJson => {
        "id": id,
        "post_id": postId,
        "creator": creator,
        "content": content,
      };
}
