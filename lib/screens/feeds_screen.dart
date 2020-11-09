import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wesurf/screens/forum_comment_screen.dart';
//import 'forum_comment_screen.dart';

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {

  Widget getMood(String mood) {
    if (mood == 'happy')
      return Icon(TablerIcons.mood_happy, size: 15, color: Color(0xff4CD964));
    else if (mood == 'neutral')
      return Icon(TablerIcons.mood_neutral, size: 15, color: Color(0XFFFE9E12));
    return Icon(TablerIcons.mood_sad, size: 15, color: Colors.red);
  }

  String timeFromNow(String t) {
    DateTime timestamp = DateTime.parse(t);
    Duration duration = DateTime.now().difference(timestamp);
    if (duration.inSeconds > 60) {
      if (duration.inMinutes > 60) {
        if (duration.inHours > 24) {
          return '${duration.inDays} days ago';
        } else
          return '${duration.inHours} hours ago';
      } else
        return '${duration.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  Future<List<Widget>> fetchPost() async {
    Firebase.initializeApp();
    var locationInstance = FirebaseFirestore.instance.collection('locations');
    var postInstance = FirebaseFirestore.instance.collection('posts');
    var userInstance = FirebaseFirestore.instance.collection('users');

    String locationUID;
    String locationName;
    String content;
    var image = null;
    String mood;
    var timestamp;
    String userUID;
    String userName;

    List<Widget> UserPosts = new List<Widget>();
    await postInstance.get().then((posts) async {
      for (var post in posts.docs) {
        content = post.data()['content'];
        image = post.data()['image'];
        mood = post.data()['mood'];
        timestamp = post.data()['timestamp'];
        locationUID = post.data()['locationUID'];
        await locationInstance
            .doc(locationUID)
            .get()
            .then((location) => locationName = location.data()['name']);
        userUID = post.data()['userUID'];
        await userInstance
            .doc(userUID)
            .get()
            .then((userValue) => userName = userValue.data()['name']);

        UserPosts.add(UserPost(
            post.id,
            userName,
            getMood(mood),
            locationName,
            timeFromNow(timestamp),
            'assets/profile_pic.png',
            image,
            content,
            59,
            24,
            120
        ));
      }
    });

    return UserPosts.reversed.toList();
  }

  @override
  void initState() {
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Explore",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: FutureBuilder(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var feedData = snapshot.data;
                return Container(
                    color: Color(0xFFF2F2F7),
                    child: ListView.builder(
                      itemCount: feedData.length,
                      itemBuilder: (context, index) {
                        return feedData[index];
                      }
                    )
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        )
    );
  }

  /* Returns the image asset string for smiley*/
  String getReaction(String reaction) {
    if (reaction == "sad") {
      return 'assets/face-sad-red.png';
    } else if (reaction == "happy") {
      return 'assets/face-smile-green.png';
    } else if (reaction == "neutral") {
      return 'assets/face-neutral-orange.png';
    } else {}
  }

  /* Main User Post builder function */
  Widget UserPost(
      String postUID,
      String username,
      Icon reaction,
      String location,
      String timeAgo,
      String avatar,
      String image,
      String content,
      int drops,
      int replies,
      int views) {
    TextEditingController comment_controller = TextEditingController();
    var screenSize = MediaQuery.of(context).size;

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Image.asset(avatar, height: 40, width: 40),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    // *User name
                    Text(username,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 3),
                    // *Reaction Icon
                    reaction
                  ]),
                  Text(
                      // *Location and time info
                      location,
                      style: TextStyle(color: Color(0xff999999), fontSize: 11)),
                  Text(
                      // *Location and time info
                      timeAgo,
                      style: TextStyle(color: Color(0xff999999), fontSize: 11)),
                ],
              ),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // * Add mate button
                        TextButton(
                          child: Text(
                            "Add Mate",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 122, 255, 1)),
                          ),
                        )
                      ]))
            ],
          ),

          Row(
            children: [
              Expanded(
                  // *Post's text
                  child: Text(content, style: TextStyle(fontSize: 14),
              ))
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                  flex: 1,
                  // *Post media
                  child: Image.network(image)
              )
            ],
          ),

          // *Function called to return widget with stats
          PostInfoRow(postUID, content, username, avatar, image, location,
              timeAgo, reaction, drops, replies, views),

          Row(children: [
            // *The comment textfield container
            Expanded(
                flex: 6,
                child: Container(
                    width: screenSize.width, // do it in both Container
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Color(0xFFF2F2F7),
                        filled: true,
                        labelText: "Write a comment",
                        isDense: true,
                        labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffB0B0B8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ))),

            // *Post button
            Expanded(
                flex: 1,
                child: TextButton(
                  child: Text(
                    "Post",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 122, 255, 1)),
                  ),
                ))
          ])
        ],
      ),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
    );
  }

  /* Sets and returns the row for the stats and icons, called in main user post widget function */
  Widget PostInfoRow(
      String postUID,
      String content,
      String username,
      String profile_img,
      String forum_img,
      String location,
      String post_time,
      Icon mood_icon,
      int drops,
      int replies,
      int views) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconButton(
            icon: (Icon(
              TablerIcons.droplet,
              color: Colors.black,
            )),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Forum_comment(
                            postUID,
                            content,
                            username,
                            profile_img,
                            forum_img,
                            location,
                            post_time,
                            mood_icon)));
              },
              icon: Icon(TablerIcons.message_circle, color: Colors.black)),
          IconButton(icon: Icon(TablerIcons.share, color: Colors.black))
        ])),
        Spacer(),
        Container(
          child: Row(
            /* Post statistics */
            children: [
              // *Stats
              Text(drops.toString(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(" drops", style: TextStyle(fontSize: 10)),
              SizedBox(width: 5),
              Text(replies.toString(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(" replies", style: TextStyle(fontSize: 10)),
              SizedBox(width: 5),
              Text(views.toString(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(" views", style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
