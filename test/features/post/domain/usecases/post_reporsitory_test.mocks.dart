// Mocks generated by Mockito 5.0.17 from annotations
// in freedomwall/test/features/post/domain/usecases/get_post_by_id_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:freedomwall/core/error/failures.dart' as _i5;
import 'package:freedomwall/features/post/domain/entities/post.dart' as _i6;
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [PostRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPostRepository extends _i1.Mock implements _i3.PostRepository {
  MockPostRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Post>> getPostById(int? postId) =>
      (super.noSuchMethod(Invocation.method(#getPostById, [postId]),
              returnValue: Future<_i2.Either<_i5.Failure, _i6.Post>>.value(
                  _FakeEither_0<_i5.Failure, _i6.Post>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.Post>>);
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Post>>> getAllPost() =>
      (super.noSuchMethod(Invocation.method(#getAllPost, []),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Post>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Post>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Post>>>);
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Post>>> getPostsByCreator(
          String? creator) =>
      (super.noSuchMethod(Invocation.method(#getPostsByCreator, [creator]),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Post>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Post>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Post>>>);
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.Post>>> getPostsByTitle(
          String? title) =>
      (super.noSuchMethod(Invocation.method(#getPostsByTitle, [title]),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i6.Post>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.Post>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.Post>>>);
}
