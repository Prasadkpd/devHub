import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? email;
  String? photoUrl;
  String? role;
  String? id;
  Timestamp? signedUpAt;
  Timestamp? lastSeen;
  bool? isOnline;

  UserModel({
    this.username,
    this.email,
    this.id,
    this.photoUrl,
    this.signedUpAt,
    this.isOnline,
    this.lastSeen,
    this.role,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    role = json['role'];
    photoUrl = json['photoUrl'];
    signedUpAt = json['signedUpAt'];
    isOnline = json['isOnline'];
    lastSeen = json['lastSeen'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = username;
    data['role'] = role;
    data['email'] = email;
    data['photoUrl'] = photoUrl;
    data['signedUpAt'] = signedUpAt;
    data['isOnline'] = isOnline;
    data['lastSeen'] = lastSeen;
    data['id'] = id;

    return data;
  }
}
