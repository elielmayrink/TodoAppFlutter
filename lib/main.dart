import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/iten.dart'; // interface para o android para android.

void main() {
  runApp(ToDoList());
}

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ToDo list",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = [];
    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTask = TextEditingController();

  void add() {
    if (newTask.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(title: newTask.text, done: false));
      save();
      newTask.text = "";
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if (data == null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((item) => Item.fromJson(item)).toList();
      setState(() {
        widget.items = result;
      });
    } else {
      data = "";
    }
  }

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("data", jsonEncode(widget.items));
  }

  _HomePageState() {
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTask,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          decoration: InputDecoration(
              labelText: "+ Adicionar tarefa",
              labelStyle: TextStyle(color: Colors.white, fontSize: 28)),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return Dismissible(
            key: Key(item.title),
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            background: Container(
              color: Colors.red.withOpacity(0.5),
            ),
            onDismissed: (direction) {
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
