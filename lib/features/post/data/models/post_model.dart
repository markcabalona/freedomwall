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
        id: json["id"] as int,
        creator: json["creator"] as String,
        title: json["title"] as String,
        content: json["content"] as String,
        dateCreated: DateTime.parse(json["date_created"] as String),
        likes: json["likes"] as int,
        dislikes: json["dislikes"] as int,
        comments: (json["comments"] as List)
            .map((jsonComment) => CommentModel.fromJson(jsonComment))
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
      };
}
