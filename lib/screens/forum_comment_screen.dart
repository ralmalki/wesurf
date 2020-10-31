import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:http/http.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wesurf/backend/comment_data.dart';
import 'package:wesurf/backend/post_data.dart';

class Forum_comment extends StatefulWidget {
  Forum_comment(
      this.postUID,
      this.content,
      this.username,
      this.profile_img,
      this.forum_img,
      this.location,
      this.post_time,
      this.mood_icon);

  final postUID;
  final content;
  final username;
  final profile_img;
  final forum_img;
  final location;
  final post_time;
  final mood_icon;

  @override
  Forum_commentState createState() => new Forum_commentState();
}

class Forum_commentState extends State<Forum_comment> 
{
  StreamController<List<Widget>> streamController = StreamController.broadcast();
  TextEditingController commentController = TextEditingController();

  String timeFromNow(String t) {
    DateTime timestamp = DateTime.parse(t);
    Duration duration = DateTime.now().difference(timestamp);
    if (duration.inSeconds > 60) {
      if (duration.inMinutes > 60) {
        if (duration.inHours > 24) {
          return '${duration.inDays} days ago';
        }
        else
          return '${duration.inHours} hours ago';
      }
      else
        return '${duration.inMinutes} minutes ago';
    }
    return 'Just now';
  }

  Future<List<Widget>> fetchComment(String postUID) async {
    print("postUID: $postUID");
    Firebase.initializeApp();
    var postInstance = FirebaseFirestore.instance.collection('posts');
    var userInstance = FirebaseFirestore.instance.collection('users');
    var commentInstance = FirebaseFirestore.instance.collection('comments');

    String content;
    var timestamp;
    String userName;

    List<Widget> CommentList = new List<Widget>();
    //fetch all post
    await postInstance.doc(postUID).get().then((value) async {
      print("post: ${value.data()}");
      //for each post fetch data
      for (var comment in value.data()['comments']) {
        print("comment: $comment");
        await commentInstance.doc(comment).get().then((commentValue) async{
          content = commentValue.data()['content'];
          timestamp = commentValue.data()['timestamp'];
          String userUID = commentValue.data()['userUID'];
          //for useUID fetch name
          await userInstance.doc(userUID).get().then((userValue) => userName = userValue.data()['name']);
        });
        print("userName: $userName");
        print("timestamp: $timestamp");
        print("comment: $comment");
        CommentList.add(_commentCard(
            userName,
            "assets/profile_pic5.png",
            widget.location,
            timeFromNow(timestamp),
            content));
      }
    });
    //get item from newest to oldest
    return CommentList.reversed.toList();
  }

  Widget _commentCard(String username, String profile_img, String location, String post_time, String comment)
  {    
    return Card(
        color: Colors.white,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _userInfo(username, profile_img, location, post_time,comment ),
          ],
        ),
      );
  }

  Widget _userInfo(String username, String profile_pic_path, String location,String post_time, String comment) 
  {
    return Container(
      height: 85,
      child:Container(
              //height: 20,
              padding: EdgeInsets.fromLTRB(10, 5, 7, 0),
              child:Row(children:[
                Column(children: [
                  Row(children: [
                    Image.asset(
                      profile_pic_path,
                      height: 40,
                      width: 40,
                    ),
                ],),
                ],),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child:Row(children: [
                      Text(username, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700)),
                      SizedBox(width:3),
                      Text(post_time,style: TextStyle(color: Colors.grey[700], fontSize: 12,fontWeight: FontWeight.normal)),
                    ],),),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    width: 329,
                    child:Text(comment,style: TextStyle(color: Colors.grey[700], fontSize: 12,fontWeight: FontWeight.normal)),
                  ),
 
              Container(
                height: 5,
                padding: EdgeInsets.fromLTRB(10, 7, 0, 0),
                width: 250,
                child:Table(
                      children: [
                      TableRow(children: [
                          TableCell(
                            child: Container(
                              height: 16,
                              child:Row(children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.thumb_up,color: Colors.grey[500], size: 15),
                            ),
                            SizedBox(width: 5),

                            Text("12",style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            SizedBox(width: 15),
                          
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.thumb_down, color:Colors.grey[500], size: 15),
                            ),
                            SizedBox(width: 5),

                            Text("3",style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            SizedBox(width: 10),

                            MaterialButton(
                                minWidth: 5,
                                height: 2,
                                textColor:  Colors.grey[600],
                                padding: EdgeInsets.fromLTRB(2.0,0,2,0),
                                onPressed: () {},
                                child: const Text('REPLY', style:TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              )
                          ]))),
                        ]),
                      ]))
                ]
              ),
              ]),
            )
    );
  }

  Widget _ForumCard(String username, String profile_img, String forum_img,
      String location, String post_time, Icon mood_icon) {
    const String str =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi congue felis ut elit dictum tincidunt. In nec orci. Phasellus at nisi vitae lorem feugiat interdum. Curabitur ultricies odio eu dolor efficitur, sit amet pretium sem elementum.";
    return Column(children: [
      Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _PostUserInfo(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 10),
              child: new Text(
                str,
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
            Image.network(
                widget.forum_img,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth),
            // Container(
            //   padding: EdgeInsets.fromLTRB(14, 5, 0, 0),
            //   child: _forumBottomTable(),
            // ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(height: 5),
                    Container(
                        height: 40,
                        width: 328,
                        padding: const EdgeInsets.fromLTRB(10.0, 6, 0, 10),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xffF2F2F7),
                            filled: true,
                            hintText: 'Write your comment',
                            hintStyle: TextStyle(fontSize: 12, height: 0.5),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        )),
                  ],
                ),
                MaterialButton(
                  minWidth: 5,
                  height: 10,
                  textColor: const Color(0xff007AFF),
                  padding: EdgeInsets.all(2.0),
                  onPressed: () {
                    setState(() {
                      _postBtn();
                    });
                  },
                  child: const Text('Post',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 10)
    ]);
  }

  //Post owner card
  Widget _PostUserInfo() {
    // String location_str = location + ' · ' + post_time + " ago";
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 1, 0),
      child: Row(
        children: <Widget>[
          Image.asset(
            widget.profile_img,
            height: 40,
            width: 40,
          ),
          SizedBox(
            width: 5,
          ),
          Container(
              height: 70,
              child: Table(
                defaultColumnWidth: FixedColumnWidth(156),
                border: TableBorder.all(
                    color: Colors.black26, width: 1, style: BorderStyle.none),
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Align(
                            child: Column(
                      children: [
                        SizedBox(
                          height: 18,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Row(children: [
                              Text(widget.username,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(width: 5),
                              widget.mood_icon,
                            ])),
                        SizedBox(
                          height: 1,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(widget.location,
                                style: TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal))),
                        SizedBox(
                          height: 1,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(widget.post_time,
                                style: TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal))),
                      ],
                    ))),
                    TableCell(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Column(children: [
                              SizedBox(
                                height: 4,
                              ),
                              MaterialButton(
                                minWidth: 70,
                                height: 20,
                                textColor: const Color(0xff007AFF),
                                padding: EdgeInsets.all(2.0),
                                onPressed: () {},
                                child: const Text('Add Friend',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ]))),
                  ]),
                ],
              )),
        ],
      ),
    );
  }

  void _postBtn() async {
    await Firebase.initializeApp();
    String userUID = FirebaseAuth.instance.currentUser.uid;
    CommentData commentData = new CommentData();
    PostData postData = new PostData(postUID: widget.postUID);
    String commentUID = await commentData.createComment(userUID, widget.postUID, commentController.text);
    postData.addComment(commentUID);
    print("post button pressed");
    streamController.add(List<Container>());
    commentController.clear();
    //Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context){
    String comment = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi congue felis ut elit dictum tincidunt. In nec orci. Phasellus at nisi vitae lorem feugiat interdum. Curabitur ultricies odio eu dolor efficitur, sit amet pretium sem elementum.";

    double appbar_h = MediaQuery.of(context).size.height * 0.08;
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    double textfield_icon_size = screen_width * 0.06;
    return new Scaffold(
      appBar:AppBar(
          title: new Text('Comments',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
            leading: new Row(children: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: Color(0xFF1A7EFF),
                child: Row(children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 17,
                    color: Color(0xFFFF1300),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Back',
                      style: TextStyle(
                          color: Color(0xFFFC2D54),
                          fontWeight: FontWeight.w700))
                ]),
              ),
            ]),
            leadingWidth: 89,
          
        backgroundColor: Colors.white,
      ),
      body:StreamBuilder(
        stream: streamController.stream,
        builder: (context, snapshot) {
          return FutureBuilder(
              future: fetchComment(widget.postUID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Widget> commentList = snapshot.data;
                  return Column(
                    children: [
                      _ForumCard(
                          widget.username,
                          'assets/profile_pic2.png',
                          widget.forum_img,
                          widget.location,
                          widget.post_time,
                          widget.mood_icon
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: commentList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return commentList[index];
                            }
                        ),
                      ),
                    ],
                  );
                }
                else
                  return SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator());
              }
          );
        })
   );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

}



