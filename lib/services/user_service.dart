import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devhub/utils/firebase.dart';

class UserService extends Service {
  String currentUid() {
    return firebaseAuth.currentUser!.uid;
  }

  setUserStatus(bool isOnline) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      userRef
          .doc(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }
}
