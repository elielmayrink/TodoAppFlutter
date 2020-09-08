import 'package:flutter/material.dart';

class Item {
  String title;
  bool done;

  Item({
    this.title,
    this.done,
  });

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titlle'] = this.title;
    data['done'] = this.done;
    return data;
  }
}
