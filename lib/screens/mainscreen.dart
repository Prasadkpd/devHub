import 'package:animations/animations.dart';
import 'package:devhub/posts/create_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:devhub/components/fab_container.dart';
import 'package:devhub/pages/notification.dart';
import 'package:devhub/pages/profile.dart';
import 'package:devhub/pages/search.dart';
import 'package:devhub/pages/feeds.dart';
import 'package:devhub/utils/firebase.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;

  List pages = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'page': Feeds(),
      'index': 0,
    },
    {
      'title': 'Search',
      'icon': Icons.search,
      'page': Search(),
      'index': 1,
    },
    {
      'title': '',
      'icon': Icons.add_circle,
      'page': CreatePost(),
      'index': 2,
    },
    {
      'title': 'Notification',
      'icon': Icons.notifications_active,
      'page': Activities(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'icon': Icons.person,
      'page': Profile(profileId: firebaseAuth.currentUser!.uid),
      'index': 4,
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
                  ?  Padding(
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
              )
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
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  buildFab() {
    return Container(
      height: 45.0,
      width: 45.0,
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
