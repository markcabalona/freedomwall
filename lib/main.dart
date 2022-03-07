import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freedomwall/core/widgets/error_widget.dart' as err;
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:freedomwall/features/post/presentation/pages/init_page.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
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
      initialRoute: '/',
    );
  }
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    RegExp postRegex = RegExp(
        r"^/posts?/?(?:([0-9]+)|((?:creator|title)=([A-Za-z0-9%'_]+)?))?/?$");
    final match = postRegex.firstMatch(settings.name ?? "");

    final url = Uri.parse(settings.name ?? "");

    if (url.hasQuery) {
      log("url has query");
      final Map<String, String> query = url.queryParameters;
      log("Query is: $query");
      String? creator, title, id;
      creator = query["creator"];
      title = query["title"];
      id = query["id"];

      if (id != null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => InitPage(
            initialEvent: GetPostByIdEvent(postId: id!),
          ),
        );
      } else {
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
    } else if (["/posts/", "/posts", "/"].contains(url.path)) {
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
