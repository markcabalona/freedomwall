import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:freedomwall/core/widgets/loading_widget.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_widget.dart';
import 'package:freedomwall/core/widgets/error_widget.dart' as err;

class HomePage extends StatelessWidget {
  final Stream<List<Post>>? posts;
  const HomePage({
    required this.posts,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return StreamBuilder<List<Post>>(
      stream: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return err.ErrorWidget(message: snapshot.error.toString());
          } else if (snapshot.hasData) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add_comment),
              ),
              appBar: AppBar(
                leadingWidth: 100,
                leading: TextButton(
                  onPressed: () {
                    Navigator.restorablePopAndPushNamed(context, '/');
                  },
                  child: const Text(
                    "FreedomWall",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    color: Colors.amber,
                    height: 30,
                  ),
                  Expanded(
                    child: MasonryGridView.builder(
                        physics: const BouncingScrollPhysics(),
                        addAutomaticKeepAlives: true,
                        addRepaintBoundaries: true,
                        // cacheExtent: 10,
                        padding: const EdgeInsets.only(
                          top: kToolbarHeight,
                          bottom: 20,
                          left: 80,
                          right: 80,
                        ),
                        gridDelegate:
                            SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: _width < 1000 ? 600 : 400,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return PostWidget(
                            post: snapshot.data![index],
                          );
                        }),
                  ),
                ],
              ),
            );
          } else {
            return const err.ErrorWidget(message: 'Empty data');
          }
        } else {
          return err.ErrorWidget(message: 'State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
