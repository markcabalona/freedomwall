
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freedomwall/core/widgets/loading_widget.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/homepage/post_widget.dart';
import 'package:freedomwall/core/widgets/error_widget.dart' as err;

class HomePage extends StatelessWidget {
  final Stream<List<Post>>? posts;
  const HomePage({
    required this.posts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const err.ErrorWidget(message: "Server Failure...");
          } else if (snapshot.hasData) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              // extendBody: true,
              appBar: AppBar(
                leadingWidth: 100,
                leading: TextButton(
                  onPressed: () {
                    Navigator.restorablePopAndPushNamed(context, '/');
                  },
                  child: const Text("FreedomWall"),
                ),
              ),
              body: MasonryGridView.builder(
                  physics: const BouncingScrollPhysics(),
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  padding: const EdgeInsets.only(
                      top: kToolbarHeight, bottom: 20, left: 100, right: 100),
                  gridDelegate:
                      const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 600,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return PostWidget(
                      post: snapshot.data![index],
                    );
                  }),
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
