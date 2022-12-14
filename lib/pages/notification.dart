import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:devhub/components/notification_stream_wrapper.dart';
import 'package:devhub/models/notification.dart';
import 'package:devhub/utils/firebase.dart';
import 'package:devhub/widgets/notification_items.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  currentUserId() {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () => deleteAllItems(),
              child: Text(
                'CLEAR',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          getActivities(),
        ],
      ),
    );
  }

  getActivities() {
    return ActivityStreamWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: notificationRef
          .doc(currentUserId())
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        ActivityModel activities =
            ActivityModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return ActivityItems(
          activity: activities,
        );
      },
    );
  }

  deleteAllItems() async {
//delete all notifications associated with the authenticated user
    QuerySnapshot notificationsSnap = await notificationRef
        .doc(firebaseAuth.currentUser!.uid)
        .collection('notifications')
        .get();
    for (var doc in notificationsSnap.docs) {
      if (doc.exists) {
        doc.reference.delete();
      }
    }
  }
}
