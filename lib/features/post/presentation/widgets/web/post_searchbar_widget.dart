import 'package:flutter/material.dart';

class PostSearchBarWidget extends StatefulWidget {
  const PostSearchBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PostSearchBarWidget> createState() => _PostSearchBarWidgetState();
}

class _PostSearchBarWidgetState extends State<PostSearchBarWidget> {
  String _searchFilter = 'title';
  final TextEditingController _searchCtrl = TextEditingController();
  final _searchKey = GlobalKey<FormFieldState>();

  void _onSubmitted(String? val, BuildContext context) {
    if (_searchKey.currentState!.validate()) {
      var _params = _searchFilter + "=" + _searchCtrl.text;
      if (_searchFilter == 'id') {
        _params = "id=" + _searchCtrl.text.replaceAll("#fw", '');
      }
      Navigator.restorablePopAndPushNamed(context, '/posts/?$_params');
    }
  }

  String? _validateSearch(String? val) {
    if (val == null) {
      return "Invalid Input";
    } else if (val.isEmpty) {
      return "Field can not be empty.";
    }

    if (_searchFilter == 'id') {
      RegExp _regex = RegExp(r'^#fw([0-9]+)$');
      return _regex.hasMatch(val) ? null : "Invalid Post ID";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // final double _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 350,
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        child: TextFormField(
          key: _searchKey,
          controller: _searchCtrl,

          onFieldSubmitted: (value) {
            _onSubmitted(value, context);
          },
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => _validateSearch(value),
          // clipBehavior: Clip.none,
          decoration: InputDecoration(
            isDense: true,
            hoverColor: Theme.of(context).primaryColorLight.withOpacity(.2),
            labelText: _searchFilter == "id"
                ? "Post ID (#fw1)..."
                : "Post " + _searchFilter + "...",
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelStyle: const TextStyle(
                color: Colors.grey, fontStyle: FontStyle.italic),
            errorStyle: TextStyle(
              backgroundColor: Colors.white,
              fontSize: Theme.of(context).textTheme.caption?.fontSize,
            ),
            suffixIcon: Container(
              padding: const EdgeInsets.only(right: 10),
              child: DropdownButton<String>(
                underline: const SizedBox(),
                items: <String>['title', 'creator', 'id'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _searchFilter = val ?? _searchFilter;
                  });
                },
                value: _searchFilter,
                style: TextStyle(color: Theme.of(context).primaryColor),
                alignment: Alignment.center,
                icon: Icon(
                  Icons.manage_search_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            border: OutlineInputBorder(
                // gapPadding: 50,
                borderRadius: BorderRadius.circular(20)),
            fillColor: Colors.white,
            filled: true,
          ),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
