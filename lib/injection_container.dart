import 'package:freedomwall/core/utils/input_converter.dart';
import 'package:freedomwall/features/post/data/datasources/firebase_datasource.dart';
import 'package:freedomwall/features/post/data/datasources/post_remote_datasource.dart';
import 'package:freedomwall/features/post/data/repositories/post_repository_impl.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';
import 'package:freedomwall/features/post/domain/usecases/create_content.dart';
import 'package:freedomwall/features/post/domain/usecases/get_post_by_id.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';
import 'package:freedomwall/features/post/domain/usecases/stream_post.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void init() {
  //! Features - Post
  //Bloc
  sl.registerFactory(
    () => PostBloc(
        streamPosts: sl<StreamPosts>(),
        createContent: sl<CreateContent>(),
        likeDislikeContent: sl<LikeDislikeContent>(),
        getPostById: sl<GetPostById>(),
        inputConverter: sl<InputConverter>()),
  );

  //! Usecases
  sl.registerLazySingleton(() => StreamPosts(repository: sl()));
  sl.registerLazySingleton(() => CreateContent(repository: sl()));
  sl.registerLazySingleton(() => LikeDislikeContent(repository: sl()));
  sl.registerLazySingleton(() => GetPostById(repository: sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(
        client: sl(),
      ));
  sl.registerLazySingleton<FirebaseDatasource>(() => FirebaseDatasource());

  //! Core
  sl.registerLazySingleton(() => InputConverter());

  //! External
  sl.registerLazySingleton(() => http.Client());
}
