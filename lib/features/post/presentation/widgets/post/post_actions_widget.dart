import 'package:flutter/material.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';
import 'package:freedomwall/features/post/presentation/widgets/comment/comments_widget.dart';
import 'package:intl/intl.dart';

class PostActionsWidget extends StatefulWidget {
  final int likes, dislikes;
  final List<Comment> comments;
  final bool showComments;

  const PostActionsWidget({
    required this.likes,
    required this.dislikes,
    required this.comments,
    required this.showComments,
    Key? key,
  }) : super(key: key);

  @override
  State<PostActionsWidget> createState() => _PostActionsWidgetState();
}

class _PostActionsWidgetState extends State<PostActionsWidget> {
  late bool _showComments;

  @override
  void initState() {
    _showComments = widget.showComments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat numFormat = NumberFormat.compact();
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("${numFormat.format(widget.likes)} likes"),
              Text("${numFormat.format(widget.dislikes)} dislikes"),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showComments = !_showComments;
                  });
                },
                style: ButtonStyle(
                  shadowColor: MaterialStateColor.resolveWith(
                      (states) => Theme.of(context).primaryColor),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                ),
                child: Text(
                  "${numFormat.format(widget.comments.length)} comments",
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
                    color: Theme.of(context).primaryColor.withOpacity(.2),
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
                              padding: const EdgeInsets.only(right: 10),
                              child: const Icon(Icons.thumb_up_alt_outlined),
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
                              padding: const EdgeInsets.only(left: 10),
                              child: const Icon(Icons.thumb_down_alt_outlined),
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
        _showComments
            ? CommentsWidget(
                comments: widget.comments,
              )
            : const SizedBox(),
      ],
    );
  }
}
