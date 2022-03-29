import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freedomwall/features/post/data/models/comment_model.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel(
      {required id,
      required creator,
      required title,
      required content,
      required dateCreated,
      required likes,
      required dislikes,
      required comments})
      : super(
          id: id,
          creator: creator,
          title: title,
          content: content,
          dateCreated: dateCreated,
          likes: likes,
          dislikes: dislikes,
          comments: comments,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: (json["id"]),
        creator: json["creator"] as String,
        title: json["title"] as String,
        content: json["content"] as String,
        dateCreated: (json["date_created"] as Timestamp).toDate(),
        likes: json["likes"] as int,
        dislikes: json["dislikes"] as int,
        comments: (json['comments'] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList(),
      );
}

class PostCreateModel extends CreateModel {
  final String title;

  const PostCreateModel({
    required String creator,
    required this.title,
    required String content,
  }) : super(content: content, creator: creator);

  @override
  Map<String, dynamic> get toJson => {
        "title": title,
        "creator": creator,
        "content": content,
        "date_created": Timestamp.fromDate(DateTime.now()),
        "likes": 0,
        "dislikes": 0,
      };
}
