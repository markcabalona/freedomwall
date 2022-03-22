import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freedomwall/features/post/data/models/post_model.dart';
import 'package:freedomwall/features/post/presentation/bloc/post_bloc.dart';

class CreatePostDialog extends StatelessWidget {
  CreatePostDialog({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _creatorCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  String? _validateContent(String? val) {
    if (val == null || val.isEmpty) {
      return "Field can not be blank.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        height: 600,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            height: 530,
            // color: Colors.amber,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 10,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "FreedomWall",
                        style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.headline3?.fontSize,
                            color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: _titleCtrl,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Post Title (Untitled)",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        errorStyle: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.caption?.fontSize,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: _creatorCtrl,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Post Creator (Anonymous)",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        errorStyle: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.caption?.fontSize,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 20,
                    child: TextFormField(
                      controller: _contentCtrl,
                      validator: (val) => _validateContent(val),
                      maxLines: 10,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Post Content",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        errorStyle: TextStyle(
                          backgroundColor: Theme.of(context).primaryColorLight,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColorLight,
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Theme.of(context).primaryColorLight),
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(.4)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<PostBloc>(context).add(
                                    CreateContentEvent(
                                        content: PostCreateModel(
                                            creator: _creatorCtrl.text.isEmpty
                                                ? "Anonymous"
                                                : _creatorCtrl.text,
                                            title: _titleCtrl.text.isEmpty
                                                ? "Untitled"
                                                : _titleCtrl.text,
                                            content: _contentCtrl.text)));

                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Sumbit Post"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Theme.of(context).primaryColorLight),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
