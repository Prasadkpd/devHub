import 'dart:async';

import 'package:flutter/material.dart';

class TextTime extends StatefulWidget {
  final Widget? child;

  const TextTime({super.key, this.child});

  @override
  // ignore: library_private_types_in_public_api
  _TextTimeState createState() => _TextTimeState();
}

class _TextTimeState extends State<TextTime> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
