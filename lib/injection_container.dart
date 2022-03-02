import 'package:freedomwall/core/utils/input_converter.dart';
import 'package:freedomwall/features/post/data/datasources/constants.dart';
import 'package:freedomwall/features/post/data/datasources/post_remote_datasource.dart';
import 'package:freedomwall/features/post/data/repositories/post_repository_impl.dart';
import 'package:freedomwall/features/post/domain/repositories/post_repository.dart';
import 'package:freedomwall/features/post/domain/usecases/create_post.dart';
import 'package:freedomwall/features/post/domain/usecases/get_post_by_id.dart';
import 'package:freedomwall/features/post/domain/usecases/get_posts.dart';
import 'package:freedomwall/features/post/domain/usecases/stream_post.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

final sl = GetIt.instance;

void init() {
  //! Features - Post
  //Bloc
  sl.registerFactory(
    () => PostBloc(
        streamPosts: sl(),
        createPost: sl(),
        getPosts: sl(),
        getPostById: sl(),
        inputConverter: sl()),
  );

  //! Usecases
  sl.registerLazySingleton(() => StreamPosts(repository: sl()));
  sl.registerLazySingleton(() => CreatePost(repository: sl()));
  sl.registerLazySingleton(() => GetPosts(repository: sl()));
  sl.registerLazySingleton(() => GetPostById(repository: sl()));

  // Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(
        client: sl(),
        channel: sl(),
      ));

  //! Core
  sl.registerLazySingleton(() => InputConverter());

  //! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(
    () {
      /*not sure if initializing websocket here is the best practice,
   but i have to close the channel after using it */
      // _channel = WebSocketChannel.connect(Uri.parse(websocketUrl));
      return WebSocketChannel.connect(Uri.parse(websocketUrl));
    },
    dispose: (WebSocketChannel channel) {
      channel.sink.close();
    },
  );
}
