import 'dart:ffi';

import 'package:flutter/material.dart';
import './model.dart';
import 'package:http/http.dart' as http;

class AddModel extends StatefulWidget {
  @override
  _AddModelState createState() => _AddModelState();
}

Future<Model> addModel(String title) async {
  final _url = 'https://jsonplaceholder.typicode.com/posts';
  final response = await http.post(_url, body: {"title": title});
  if (response.statusCode == 200) {
    final String responseString = response.body;
    return modelFromJson(responseString);
  } else {
    return null;
  }
}

class _AddModelState extends State<AddModel> {
  final titleController = TextEditingController();
  Future<Void> _submit(Model _mod) async {
    final title = titleController.text;
    final Model model = await addModel(title);
    setState(() {
      _mod = model;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Title'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  controller: titleController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    FlatButton(onPressed: () => _submit, child: Text("Submit")),
              ),
            ],
          ),
        ));
  }
}
