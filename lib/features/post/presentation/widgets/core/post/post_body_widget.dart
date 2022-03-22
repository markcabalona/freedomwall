import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class PostBodyWidget extends StatefulWidget {
  final bool? isExpanded;
  final String text;
  const PostBodyWidget({
    required this.text,
    this.isExpanded,
    Key? key,
  }) : super(key: key);

  @override
  State<PostBodyWidget> createState() => _PostBodyWidgetState();
}

class _PostBodyWidgetState extends State<PostBodyWidget> {
  late bool _isExpanded;
  @override
  void initState() {
    _isExpanded = widget.isExpanded ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final tp = TextPainter(
      maxLines: 4,
      text: TextSpan(
        text: widget.text,
        style: TextStyle(
          overflow: TextOverflow.visible,
          fontSize: Theme.of(context).textTheme.subtitle2!.fontSize,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    );
    // log(tp.didExceedMaxLines.toString());
    tp.layout(
        maxWidth: _width < 1000
            ? (_width > 760 ? (_width / 2) : _width) - 160
            : (_width / 3) - 160);

    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: _isExpanded ? Curves.easeOut : Curves.bounceOut,
      child: Column(
        children: [
          SelectableText(tp.text!.toPlainText(),
              textAlign: TextAlign.left,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              // overflow: TextOverflow.fade,
              maxLines: _isExpanded ? null : tp.maxLines,
              style: tp.text!.style),
          tp.didExceedMaxLines
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(_isExpanded ? "See less" : "...See more"),
                )
              : const SizedBox(
                  height: 12,
                ),
        ],
      ),
    );
  }
}
