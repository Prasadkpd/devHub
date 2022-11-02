import 'package:flutter/material.dart';

AppBar header(context) {
  return AppBar(
    title: Text('Wooble'),
    centerTitle: true,
    actions: [Padding(
      padding: const EdgeInsets.only(right:20.0),
      child: Icon(Icons.notifications_outlined),
    )],
  );
}
