import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  const ErrorWidget({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
          fontSize: Theme.of(context).textTheme.headline5?.fontSize,
        ),
      ),
    );
  }
}
