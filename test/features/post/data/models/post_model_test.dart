import 'package:flutter_test/flutter_test.dart';
import 'package:freedomwall/features/post/data/models/comment_model.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';

void main() {
  group('PostModel Test.', () {
    final expectedPostModel = PostModel(
      id: 1,
      title: "Test Title",
      content: "Test Content",
      creator: "Test Creator",
      dateCreated: DateTime.now(),
      comments: <Comment>[
        CommentModel(
          id: 1,
          postId: 1,
          content: "Test Content",
          creator: "Test Creator",
          dateCreated: DateTime.now(),
          dislikes: 0,
          likes: 0,
        ),
      ],
      dislikes: 0,
      likes: 0,
    );

    //example reponse of api for fetching Posts
    final Map<String, dynamic> tJsonMap = {
      "id": expectedPostModel.id,
      "title": expectedPostModel.title,
      "creator": expectedPostModel.creator,
      "content": expectedPostModel.content,
      "date_created": expectedPostModel.dateCreated.toString(),
      "likes": expectedPostModel.likes,
      "dislikes": expectedPostModel.dislikes,
      "comments": expectedPostModel.comments
          .map((comment) => CommentModel(
                id: comment.id,
                postId: comment.postId,
                creator: comment.creator,
                content: comment.content,
                dateCreated: comment.dateCreated,
                likes: comment.likes,
                dislikes: comment.dislikes,
              ).toJson
                ..addEntries([
                  MapEntry("date_created", expectedPostModel.dateCreated.toString()),
                  MapEntry("likes", expectedPostModel.likes),
                  MapEntry("dislikes", expectedPostModel.dislikes),
                ]))
          .toList(),
    };
    test('Should be a subclass of Post entity.', () async {
      expect(expectedPostModel, isA<Post>());
    });

    test('fromJson. Should get a PostModel.', () async {
      PostModel result = PostModel.fromJson(tJsonMap);
      expect(result, expectedPostModel);
    });
    test('toJson. Should get a jsonMap', () async {
      //example json to post(http request) a Post to the API
      Map<String, dynamic> expectedMap = {
        "id": expectedPostModel.id,
        "title": expectedPostModel.title,
        "creator": expectedPostModel.creator,
        "content": expectedPostModel.content,
      };

      Map<String, dynamic> result = expectedPostModel.toJson;
      expect(result, expectedMap);
    });
  });
}
