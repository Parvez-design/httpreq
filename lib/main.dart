import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:httpreq/addmodel.dart';
import './model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Http Requests',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Http Requests'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Model>> getModel() async {
    final url = "https://jsonplaceholder.typicode.com/posts";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonmodel = jsonDecode(response.body);
      List<Model> model =
          jsonmodel.map((dynamic mod) => Model.fromJson(mod)).toList();
      return model;
    } else {
      throw "error";
    }
  }

  void _submit() {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext ctx) => AddModel()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: _submit)
          ],
        ),
        body: Center(
          child: FutureBuilder(
            future: getModel(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Model>> snapshot) {
              if (snapshot.hasData) {
                List<Model> data = snapshot.data;
                return ListView(
                    children: data
                        .map((Model model) => ListTile(
                              title: Text("${model.id}"),
                              subtitle: Text(model.body),
                            ))
                        .toList());
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
