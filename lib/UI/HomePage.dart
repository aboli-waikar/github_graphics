import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TreeViewController ctrFromJson = TreeViewController(
      children: [ Node(key: "1", label: "GitHub Server", children: []),]);

  Future getGitHubData() async {
    Uri url = Uri.parse("https://api.github.com/users/aboli-waikar/repos");
    final response = await http.get(url);

    List jsonList = jsonDecode(response.body);
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonList);

    list.forEach((element) {
      var id = element['id'].toString();
      var bId = "b$id";
      element.putIfAbsent('key', () => id);
      element.putIfAbsent('label', () => element['name']);
      element.putIfAbsent('children', () => [{'key': bId, "label": "Branches", "children": [] }]);
    });

    List<Map<String, dynamic>> root = [{'key': "0", "label": "GitHub Server", "children": list }];

    ctrFromJson = ctrFromJson.loadMap(list: root);
  }

  @override
  Widget build(BuildContext context) {
    getGitHubData();
    return Scaffold(
      appBar: AppBar(title: Text("Tree view example in flutter"),),
      body: Column(
        children: [
          //Card(child: Text("Hello"),),
          Container(
            height: 500,
            color: Colors.grey,
            child: TreeView(
              controller: ctrFromJson,

              //TreeViewController(children: [ Node(key: "1",label: palak[1],children: [Node(key: "2", label: balak[1])]),]),
            ),
          ),
        ],
      ),

    );
  }
}
