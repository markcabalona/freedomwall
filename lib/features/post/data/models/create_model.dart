abstract class CreateModel {
  final String creator;
  final String content;

  const CreateModel({
    required this.creator,
    required this.content,
  });

  Map<String, dynamic> get toJson;
}
