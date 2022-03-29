import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class PostHeaderWidget extends StatelessWidget {
  final String title;
  final String creator;
  final String postId;
  final DateTime dateCreated;

  const PostHeaderWidget({
    required this.title,
    required this.creator,
    required this.postId,
    required this.dateCreated,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('E, MMM d, y - ').add_jm();
    return SizedBox(
      height: 100,
      // Title | Creator
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            dateFormatter.format(dateCreated),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: Theme.of(context).textTheme.caption!.fontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height:12,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.restorablePopAndPushNamed(
                    context, '/post/?id=' + postId);
              },
              style: ButtonStyle(
                shadowColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).primaryColor),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 2.5,
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.restorablePopAndPushNamed(
                    context, '/post/?creator=' + creator);
              },
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
          ),
        ],
      ),
    );
  }
}
