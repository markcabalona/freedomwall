import 'package:flutter/material.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';

class CommentsWidget extends StatefulWidget {
  final List<Comment> comments;
  const CommentsWidget({required this.comments, Key? key}) : super(key: key);

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  List<Comment> _commentsToShow = [];

  @override
  void initState() {
    _loadMore();
    super.initState();
  }

  void _loadMore() {
    setState(() {
      _commentsToShow.addAll(
        widget.comments.getRange(
            _commentsToShow.length,
            _commentsToShow.length + 10 > widget.comments.length
                ? widget.comments.length
                : _commentsToShow.length + 10),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      child: Column(
        children: [
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          const Text("Comments"),
          widget.comments.length + 1 > _commentsToShow.length
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _loadMore();
                    });
                  },
                  child: const Text("Load more comments"),
                )
              : const SizedBox(
                  height: 12,
                ),
        ],
      ),
    );
  }
}
