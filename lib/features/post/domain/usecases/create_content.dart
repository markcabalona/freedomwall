import 'package:dartz/dartz.dart';
import 'package:freedomwall/core/error/failures.dart';
import 'package:freedomwall/core/usecases/usecase.dart';
import 'package:freedomwall/features/post/data/models/create_model.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';

class CreateContent implements UseCase<void, CreateModel> {
  final PostRepository repository;

  CreateContent({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateModel post) async {
    return await repository.createContent(post);
  }
}
