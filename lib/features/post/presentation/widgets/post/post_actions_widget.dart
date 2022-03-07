import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostActionsWidget extends StatelessWidget {
  final int likes, dislikes, numOfComments;

  const PostActionsWidget({
    required this.likes,
    required this.dislikes,
    required this.numOfComments,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat numFormat = NumberFormat.compact();
    return SizedBox(
      height: 80,
      // width: widget.width,
      child: Column(
        children: [
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${numFormat.format(likes + 10000)} likes"),
                Text("${numFormat.format(dislikes + 100)} dislikes"),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shadowColor: MaterialStateColor.resolveWith(
                        (states) => Theme.of(context).primaryColor),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.transparent),
                  ),
                  child: Text(
                    "${numFormat.format(numOfComments)} comments",
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
                                child:
                                    const Icon(Icons.thumb_down_alt_outlined),
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
    );
  }
}
