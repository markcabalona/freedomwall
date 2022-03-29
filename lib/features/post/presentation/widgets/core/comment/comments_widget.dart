import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomwall/features/post/data/models/comment_model.dart';
import 'package:freedomwall/features/post/domain/entities/comment.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';

class CommentsWidget extends StatefulWidget {
  final List<Comment> comments;
  final String postId;
  const CommentsWidget({required this.comments, required this.postId, Key? key})
      : super(key: key);

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final List<Comment> _commentsToShow = [];
  final _commentCtrl = TextEditingController();
  final _commentKey = GlobalKey<FormFieldState>();
  late bool _commentValid;

  @override
  void initState() {
    _loadMore();
    _commentValid = true;
    super.initState();
  }

  void _loadMore() {
    setState(() {
      _commentsToShow.addAll(
        widget.comments.getRange(
            _commentsToShow.length,
            _commentsToShow.length + 5 > widget.comments.length
                ? widget.comments.length
                : _commentsToShow.length + 5),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Theme.of(context).primaryColor,
        ),
        ...List<Widget>.generate(
          _commentsToShow.length,
          (index) => Container(
            width: 600,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _commentsToShow[index].creator,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SelectableText(
                  _commentsToShow[index].content,
                  textAlign: TextAlign.left,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  // overflow: TextOverflow.fade,
                  maxLines: null,
                ),
              ],
            ),
          ),
        ),
        widget.comments.length > _commentsToShow.length
            ? TextButton(
                onPressed: () {
                  setState(() {
                    _loadMore();
                  });
                },
                child: const Text("Load more comments"),
              )
            : const SizedBox(),
        const SizedBox(
          height: 12,
        ),
        Stack(children: [
          TextFormField(
            controller: _commentCtrl,
            key: _commentKey,
            validator: (val) {
              if (val == null || val.isEmpty) {
                setState(() {
                  _commentValid = false;
                });
                return "Comment can not be empty";
              } else {
                setState(() {
                  _commentValid = true;
                });
                return null;
              }
            },
            maxLines: null,
            style: TextStyle(color: Theme.of(context).primaryColor),
            decoration: InputDecoration(
              isDense: true,
              labelText: "Write a comment...",
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: const TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic),
              errorStyle: TextStyle(
                backgroundColor: Theme.of(context).primaryColorLight,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: Colors.transparent,
              filled: true,
            ),
          ),
          Positioned(
            bottom: _commentValid ? 0 : 24,
            right: 0,
            child: IconButton(
              onPressed: () {
                if (_commentKey.currentState!.validate()) {
                  BlocProvider.of<PostBloc>(context).add(
                    CreateContentEvent(
                      content: CommentCreateModel(
                          postId: widget.postId,
                          creator: "Anonymous",
                          content: _commentCtrl.text),
                    ),
                  );
                  _commentCtrl.clear();
                }
              },
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
              splashRadius: 20,
              splashColor: Colors.transparent,
              highlightColor: Theme.of(context).primaryColor.withOpacity(.2),
            ),
          )
        ]),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
