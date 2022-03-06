
import 'package:flutter/material.dart';

class PostHeaderWidget extends StatelessWidget {
  final String title;
  final String creator;
  final String postId;

  const PostHeaderWidget({
    required this.title,
    required this.creator,
    required this.postId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      // Title | Creator
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.restorablePopAndPushNamed(
                      context, '/post/' + postId);
                },
                style: ButtonStyle(
                  shadowColor: MaterialStateColor.resolveWith(
                      (states) => Theme.of(context).primaryColor),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                ),
                child: Text(
                  "#fw" + postId,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(.80),
                    fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            style: ButtonStyle(
              shadowColor: MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).primaryColor),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
            ),
            child: Text(
              "- " + creator,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).primaryColor.withOpacity(.80),
                fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
