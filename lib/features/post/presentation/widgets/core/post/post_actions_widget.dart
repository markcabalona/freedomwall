import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';
import 'package:freedomwall/features/post/domain/usecases/like_dislike_content.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';
import 'package:freedomwall/features/post/presentation/widgets/core/comment/comments_widget.dart';

import 'package:intl/intl.dart';

class PostActionsWidget extends StatefulWidget {
  final int likes, dislikes;
  final String postId;
  final List<Comment> comments;
  final bool showComments;

  const PostActionsWidget({
    required this.postId,
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
  late bool _liked;
  late bool _disliked;
  @override
  void initState() {
    _showComments = widget.showComments;
    _liked = _disliked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat numFormat = NumberFormat.compact();
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:CrossAxisAlignment.center,
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
                      color: Theme.of(context).primaryColor.withOpacity(.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Like
                        Expanded(
                          child: SizedBox.expand(
                            child: TextButton(
                              onPressed: () {
                                BlocProvider.of<PostBloc>(context).add(
                                  LikeDislikePostEvent(
                                    params: PostActionsParams(
                                      postId: widget.postId,
                                      action: _liked
                                          ? ParamsAction.unLike
                                          : ParamsAction.like,
                                    ),
                                  ),
                                );
                                if (_disliked) {
                                  BlocProvider.of<PostBloc>(context).add(
                                    LikeDislikePostEvent(
                                      params: PostActionsParams(
                                        postId: widget.postId,
                                        action: ParamsAction.unDislike,
                                      ),
                                    ),
                                  );
                                }
                                setState(() {
                                  _disliked = false;
                                  _liked = !_liked;
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(_liked
                                    ? Icons.thumb_up_alt
                                    : Icons.thumb_up_alt_outlined),
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
                              onPressed: () {
                                BlocProvider.of<PostBloc>(context).add(
                                  LikeDislikePostEvent(
                                    params: PostActionsParams(
                                      postId: widget.postId,
                                      action: _disliked
                                          ? ParamsAction.unDislike
                                          : ParamsAction.dislike,
                                    ),
                                  ),
                                );
                                if (_liked) {
                                  BlocProvider.of<PostBloc>(context).add(
                                    LikeDislikePostEvent(
                                      params: PostActionsParams(
                                        postId: widget.postId,
                                        action: ParamsAction.unLike,
                                      ),
                                    ),
                                  );
                                }
                                setState(() {
                                  _liked = false;
                                  _disliked = !_disliked;
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(_disliked
                                    ? Icons.thumb_down_alt
                                    : Icons.thumb_down_alt_outlined),
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
                        onPressed: () {
                          setState(() {
                            _showComments = true;
                          });
                        },
                        child: const Icon(Icons.comment_outlined),
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
                  postId: widget.postId,
                )
              : const SizedBox(
                  height: 4,
                ),
        ],
      ),
    );
  }
}
