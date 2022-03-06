import 'package:flutter/material.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_body_widget.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_header_widget.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final double height = 200;
  final double? width;
  final bool? isExpanded;
  // final Widget header;
  const PostWidget({
    required this.post,
    this.isExpanded,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with AutomaticKeepAliveClientMixin {
  late bool _isExpanded;
  late double width;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _isExpanded = super.widget.isExpanded ?? false;
    width = super.widget.width ?? 400;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    NumberFormat numFormat = NumberFormat.compact();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.height,
        maxWidth: width,
        minWidth: 400,
      ),
      child: Card(
        elevation: 10,
        shadowColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              PostHeaderWidget(
                title: widget.post.title,
                creator: widget.post.creator,
                postId: widget.post.id.toString(),
              ),
              // Body - post content
              PostBodyWidget(text: widget.post.content),
              //Like | Dislike | Comment
              SizedBox(
                height: 80,
                width: widget.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              "${numFormat.format(widget.post.likes + 10000)} likes"),
                          Text(
                              "${numFormat.format(widget.post.dislikes + 100)} dislikes"),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              shadowColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent),
                            ),
                            child: Text(
                              "${numFormat.format(widget.post.comments.length)} comments",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          // Like | Dislike
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  // Like
                                  Expanded(
                                    child: SizedBox.expand(
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: const Icon(
                                              Icons.thumb_up_alt_outlined),
                                        ),
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: Theme.of(context).primaryColor,
                                    indent: 8,
                                    endIndent: 8,
                                  ),
                                  // Dislike
                                  Expanded(
                                    child: SizedBox.expand(
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: const Icon(
                                              Icons.thumb_down_alt_outlined),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          // Comment
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SizedBox.expand(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Icon(Icons.comment_outlined),
                                  // color: Theme.of(context).primaryColor,
                                  // hoverColor: Colors.transparent,
                                  // highlightColor: Colors.transparent,
                                  // splashColor: Colors.transparent,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
