import 'package:equatable/equatable.dart';

abstract class Content extends Equatable {
  final String id;
  final String creator;
  final String content;
  final DateTime dateCreated;
  final int likes;
  final int dislikes;

  const Content({
    required this.id,
    required this.creator,
    required this.content,
    required this.dateCreated,
    required this.likes,
    required this.dislikes,
  });

  @override
  List<Object?> get props =>
      [id, creator, content, dateCreated, likes, dislikes];
}
