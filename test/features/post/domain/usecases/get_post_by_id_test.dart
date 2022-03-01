import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';
import 'package:freedomwall/features/post/domain/usecases/get_post_by_id.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'post_reporsitory_test.mocks.dart';

@GenerateMocks([PostRepository])
void main() {
  group("getPostById Test.", () {
    late MockPostRepository mockPostRepository;
    late GetPostById byIdUsecase;
    setUp(() {
      mockPostRepository = MockPostRepository();
      byIdUsecase = GetPostById(repository: mockPostRepository);
    });

    int tPostId = 1;
    Post tPost = Post(
      id: tPostId,
      title: "Test Title",
      content: "Test Content",
      creator: "Test Creator",
      dateCreated: DateTime.now(),
      comments: const [],
      dislikes: 0,
      likes: 0,
    );
    Failure tFailure = const Failure(message: "Failure");
    test(
      'Should get a Post with a given postId.',
      () async {
        when(mockPostRepository.getPostById(any))
            .thenAnswer((_) async => Right(tPost));

        final result = await byIdUsecase(tPostId);
        expect(result, Right(tPost));
        verify(mockPostRepository.getPostById(tPostId));
        verifyNoMoreInteractions(mockPostRepository);
      },
    );

    test(
      'Should get a Failure if postId does not exist.',
      () async {
        when(mockPostRepository.getPostById(any))
            .thenAnswer((_) async => Left(tFailure));

        final result = await byIdUsecase(tPostId);
        expect(result, Left(tFailure));
        verify(mockPostRepository.getPostById(tPostId));
        verifyNoMoreInteractions(mockPostRepository);
      },
    );
  });
}
