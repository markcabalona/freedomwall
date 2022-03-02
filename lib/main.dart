
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
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Theme.of(context).primaryColor,
        ),
      ),
      onGenerateRoute: Router.generateRoute,
      initialRoute: '/',
    );
  }
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    RegExp postRegex = RegExp(r'^/posts?/?([0-9]+)?/?(comments)?/?$');
    final match = postRegex.firstMatch(settings.name ?? "");

    if (settings.name == '/') {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const InitPage(
          initialEvent: Left(StreamPostsEvent()),
        ),
      );
    }
    if (match != null) {
      //if no post id specified in url return all posts
      if (match.group(1) == null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const InitPage(
            initialEvent: Left(StreamPostsEvent()),
          ),
        );
      } else if (match.group(2) == null) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => InitPage(
            initialEvent: Right(
              GetPostByIdEvent(postId: match.group(1)!),
            ),
          ),
        );
      } else {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Text(
              "Comment Page for PostId ${match.group(1)}: ${match.group(2)}"),
        );
      }
    } else {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const err.ErrorWidget(
          message: "Page Not Found",
        ),
      );
    }
  }
}
