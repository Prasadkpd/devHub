import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devhub/auth/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:devhub/components/stream_grid_wrapper.dart';
import 'package:devhub/models/post.dart';
import 'package:devhub/models/user.dart';
import 'package:devhub/screens/edit_profile.dart';
import 'package:devhub/screens/list_posts.dart';
import 'package:devhub/screens/settings.dart';
import 'package:devhub/utils/firebase.dart';
import 'package:devhub/widgets/post_tiles.dart';

class Profile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final profileId;

  Profile({this.profileId});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool isLoading = false;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  UserModel? users;
  final DateTime timestamp = DateTime.now();
  ScrollController controller = ScrollController();

  currentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('DEVHUB'),
        actions: [
          widget.profileId == firebaseAuth.currentUser!.uid
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: GestureDetector(
                      onTap: () async {
                        await firebaseAuth.signOut();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const Login(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            toolbarHeight: 5.0,
            collapsedHeight: 6.0,
            expandedHeight: 225.0,
            flexibleSpace: FlexibleSpaceBar(
              background: StreamBuilder(
                stream: usersRef.doc(widget.profileId).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromJson(
                      snapshot.data!.data() as Map<String, dynamic>,
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: user.photoUrl!.isEmpty
                                  ? CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      child: Center(
                                        child: Text(
                                          '${user.username![0].toUpperCase()}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 40.0,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        '${user.photoUrl}',
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15.0),
                                Row(
                                  children: [
                                    const Visibility(
                                      visible: false,
                                      child: SizedBox(width: 10.0),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 130.0,
                                          child: Text(
                                            user.username!,
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w900,
                                            ),
                                            maxLines: null,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 130.0,
                                          child: Text(
                                            user.role!,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.email!,
                                              style: const TextStyle(
                                                fontSize: 10.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    widget.profileId == currentUserId()
                                        ? Container(
                                            // color: Colors.red,
                                            margin: const EdgeInsets.only(
                                                left: 40.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) => Setting(),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.settings_outlined,
                                                    size: 30,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                  const Text(
                                                    'settings',
                                                    style: TextStyle(
                                                      fontSize: 11.5,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : const Text('')
                                    // : buildLikeButton()
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 50.0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: postRef
                                      .where('ownerId',
                                          isEqualTo: widget.profileId)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot<Object?>? snap =
                                          snapshot.data;
                                      List<DocumentSnapshot> docs = snap!.docs;
                                      return buildCount(
                                          "POSTS", docs.length ?? 0);
                                    } else {
                                      return buildCount("POSTS", 0);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 0.3,
                                    color: Colors.grey,
                                  ),
                                ),
                                StreamBuilder(
                                  stream: followersRef
                                      .doc(widget.profileId)
                                      .collection('userFollowers')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot<Object?>? snap =
                                          snapshot.data;
                                      List<DocumentSnapshot> docs = snap!.docs;
                                      return buildCount(
                                          "FOLLOWERS", docs.length ?? 0);
                                    } else {
                                      return buildCount("FOLLOWERS", 0);
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 0.3,
                                    color: Colors.grey,
                                  ),
                                ),
                                StreamBuilder(
                                  stream: followingRef
                                      .doc(widget.profileId)
                                      .collection('userFollowing')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      QuerySnapshot<Object?>? snap =
                                          snapshot.data;
                                      List<DocumentSnapshot> docs = snap!.docs;
                                      return buildCount(
                                          "FOLLOWING", docs.length ?? 0);
                                    } else {
                                      return buildCount("FOLLOWING", 0);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        buildProfileButton(user),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index > 0) return null;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            'All Posts',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () async {
                              DocumentSnapshot doc =
                                  await usersRef.doc(widget.profileId).get();
                              var currentUser = UserModel.fromJson(
                                doc.data() as Map<String, dynamic>,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ListPosts(
                                    userId: widget.profileId,
                                    username: currentUser.username,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.grid_3x3_outlined),
                          )
                        ],
                      ),
                    ),
                    buildPostView()
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  buildCount(String label, int count) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
            fontFamily: 'Ubuntu-Regular',
          ),
        ),
        const SizedBox(height: 3.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Ubuntu-Regular',
          ),
        )
      ],
    );
  }

  buildProfileButton(user) {
    //if isMe then display "edit profile"
    bool isMe = widget.profileId == firebaseAuth.currentUser!.uid;
    if (isMe) {
      return buildButton(
          text: "Edit Profile",
          function: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EditProfile(
                  user: user,
                ),
              ),
            );
          });
      //if you are already following the user then "unfollow"
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        function: handleUnfollow,
      );
      //if you are not following the user then "follow"
    } else if (!isFollowing) {
      return buildButton(
        text: "Follow",
        function: handleFollow,
      );
    }
  }

  buildButton({String? text, Function()? function}) {
    return Center(
      child: GestureDetector(
        onTap: function!,
        child: Container(
          height: 40.0,
          width: 200.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).colorScheme.secondary,
                const Color(0xff597FDB),
              ],
            ),
          ),
          child: Center(
            child: Text(
              text!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  handleUnfollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    setState(() {
      isFollowing = false;
    });
    //remove follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove following
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove from notifications feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    setState(() {
      isFollowing = true;
    });
    //updates the followers collection of the followed user
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .set({});
    //updates the following collection of the currentUser
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    //update the notification feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .set({
      "type": "follow",
      "ownerId": widget.profileId,
      "username": users?.username,
      "userId": users?.id,
      "userDp": users?.photoUrl,
      "timestamp": timestamp,
    });
  }

  buildPostView() {
    return buildGridPost();
  }

  buildGridPost() {
    return StreamGridWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: postRef
          .where('ownerId', isEqualTo: widget.profileId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        PostModel posts =
            PostModel.fromJson(snapshot.data() as Map<String, dynamic>);
        return PostTile(
          post: posts,
        );
      },
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: favUsersRef
          .where('postId', isEqualTo: widget.profileId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
          return GestureDetector(
            onTap: () {
              if (docs.isEmpty) {
                favUsersRef.add({
                  'userId': currentUserId(),
                  'postId': widget.profileId,
                  'dateCreated': Timestamp.now(),
                });
              } else {
                favUsersRef.doc(docs[0].id).delete();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0,
                  )
                ],
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  docs.isEmpty
                      ? Icons.code_outlined
                      : Icons.code_off_outlined,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
