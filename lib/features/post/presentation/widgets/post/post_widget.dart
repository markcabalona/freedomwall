import 'package:flutter/material.dart';
import 'package:freedomwall/features/post/domain/entities/post.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_actions_widget.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_body_widget.dart';
import 'package:freedomwall/features/post/presentation/widgets/post/post_header_widget.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final double height = 200;
  final double? width;
  final bool? isExpanded;
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
  late final bool _isExpanded;
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
    return Center(
      child: ConstrainedBox(
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
                PostBodyWidget(
                  text: widget.post.content,
                  isExpanded: _isExpanded,
                ),
                //Like | Dislike | Comment
                PostActionsWidget(
                  postId: widget.post.id,
                  likes: widget.post.likes,
                  dislikes: widget.post.dislikes,
                  comments: widget.post.comments,
                  showComments: _isExpanded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
