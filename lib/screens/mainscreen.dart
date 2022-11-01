import 'package:animations/animations.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;

  List pages = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'page': const Text("Hello World"),
      'index': 0,
    },
    {
      'title': 'Search',
      'icon': Icons.search,
      'page': const Text("Second"),
      'index': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_page]['page'],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            for (Map item in pages)
              item['index'] == 2
                  ? buildFab()
                  : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: IconButton(
                        icon: Icon(
                          item['icon'],
                          color: item['index'] != _page
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black
                              : Theme.of(context).colorScheme.secondary,
                          size: 25.0,
                        ),
                        onPressed: () => navigationTapped(item['index']),
                      ),
                    ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }

  buildFab() {
    return Container(
      height: 45.0,
      width: 45.0,
      child: null,
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
