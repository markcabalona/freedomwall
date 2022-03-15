import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomwall/core/widgets/error_widget.dart' as err;
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:freedomwall/features/post/presentation/pages/init_page.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(BlocProvider(
    create: (context) => di.sl<PostBloc>(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
            // backgroundColor: Colors.transparent,
            // shadowColor: Colors.transparent,
            // foregroundColor: Theme.of(context).primaryColor,
            ),
      ),
      onGenerateRoute: Router.generateRoute,
      // initialRoute: '/',
    );
  }
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final url = Uri.parse(settings.name ?? "");

    if (url.hasQuery) {
      final Map<String, String> query = url.queryParameters;
      String? creator, title, id;
      creator = query["creator"];
      title = query["title"];
      id = query["id"];

      if (id != null) {
        log("By id");
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => InitPage(
            initialEvent: GetPostByIdEvent(postId: id!),
          ),
        );
      } else {
        log("Get by title or creator");
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => InitPage(
            initialEvent: GetPostsEvent(
              creator: creator,
              title: title,
            ),
          ),
        );
      }
    } else if (["/posts/", "/posts", "/",""].contains(url.path)) {
      log("Stream all");
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const InitPage(
          initialEvent: StreamPostsEvent(),
        ),
      );
    }
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => const err.ErrorWidget(
        message: "Page Not Found",
      ),
    );
  }
}
