import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Explore",
          style: TextStyle(
              fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
          color: Color(0xFFF2F2F7),
          child: ListView(children: [
            SizedBox(height: 10),
            UserPost(
                // String userdetails(name), String reaction, String location, int timeAgo, String imageURI (icon), mediaURI (post photos), int drops, int replies, int views
                "Blue Whittle",
                "sad",
                "North Wollongong Beach",
                21,
                "https://images.unsplash.com/photo-1523419409543-a5e549c1faa8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1886&q=80",
                "https://assets.atdw-online.com.au/images/126d248fcc766b1acc3a61a74dff6023.jpeg?rect=0,0,2048,1536&w=745&h=559&&rot=360",
                23,
                4,
                42),
            UserPost(
                // String userdetails (name), String reaction, String location, int timeAgo, String imageURI (icon), mediaURI (post photos),int drops, int replies, int views
                "Selena Mcclain",
                "happy",
                "Warilla Beach",
                28,
                "https://images.unsplash.com/photo-1525879000488-bff3b1c387cf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1868&q=80",
                "https://illawarrasurfacademy.com.au/wp-content/uploads/2017/03/Warilla-Beach.jpg",
                33,
                10,
                60)
          ])),
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
      String userdetails,
      String reaction,
      String location,
      int timeAgo,
      String imageURI,
      String mediaURI,
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
              //* User avatar
              IconButton(
                  icon: Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(imageURI)))),
                  iconSize: 40,
                  onPressed: () => null),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // *User name
                    Text(userdetails,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(width: 3),
                    // *Reaction Icon
                    Image.asset(
                      getReaction(reaction),
                      height: 17.5,
                    )
                  ]),
                  Text(
                      // *Location and time info
                      location + "  ●  " + timeAgo.toString() + "m ago ",
                      style: TextStyle(fontSize: 10)),
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
                  child: Text(
                "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam"
                " erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et"
                " ea rebum.",
                style: TextStyle(
                  fontSize: 14,
                ),
              ))
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                  flex: 1,
                  // *Post media
                  child: Image.network(
                    mediaURI,
                    width: screenSize.width,
                  ))
            ],
          ),

          // *Function called to return widget with stats
          PostInfoRow(drops, replies, views),

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
  Widget PostInfoRow(int drops, int replies, int views) {
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
