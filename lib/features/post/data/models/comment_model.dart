import 'package:cloud_firestore/cloud_firestore.dart';
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
        id: json["id"],
        postId: json["post_id"],
        creator: json["creator"],
        content: json["content"],
        dateCreated: (json["date_created"] as Timestamp).toDate(),
        likes: json["likes"] as int,
        dislikes: json["dislikes"] as int,
      );
}

class CommentCreateModel extends CreateModel {
  final String postId;
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
        "date_created": Timestamp.fromDate(DateTime.now()),
        "likes": 0,
        "dislikes": 0,
      };
}
