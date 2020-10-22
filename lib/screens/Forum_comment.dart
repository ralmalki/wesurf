import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class Forum_comment extends StatefulWidget {
  @override
  Forum_commentState createState() => new Forum_commentState();
}

class Forum_commentState extends State<Forum_comment> 
{

  TextEditingController commentController = TextEditingController();

  Widget _ForumCard(String username, String profile_img, String forum_img,String location, String post_time, String comment) 
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
    String location_str = " "+post_time + " days ago";
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
                      Text(location_str,style: TextStyle(color: Colors.grey[700], fontSize: 12,fontWeight: FontWeight.normal)),
                    ],),),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                    width: 329,
                    child:Text("piscing el consectetur adipiscing elit. Morbi congue felis ut elit dictum tincidunt.",style: TextStyle(color: Colors.grey[700], fontSize: 12,fontWeight: FontWeight.normal)),
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

  Widget _forumBottomTable() {
    IconButton commentButton = IconButton(
      iconSize:25.0, 
      icon: Icon(TablerIcons.message_circle),
      onPressed: (){
        setState(() {
        Navigator.push(context,MaterialPageRoute(builder: (context) => Forum_comment()));
      });
      });
    return Table(
        //defaultColumnWidth:FixedColumnWidth(100),
        border: TableBorder.all(
            color: Colors.black26, width: 1, style: BorderStyle.none),
        children: [
          TableRow(children: [
            TableCell(
                child: Row(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(TablerIcons.droplet, size: 25),
              ),
              //SizedBox(width: 10),
              Align(
                alignment: Alignment.topLeft,
                child: commentButton,
              ),
             // SizedBox(width: 10),
              Align(
                alignment: Alignment.topLeft,
                child: Icon(TablerIcons.share, size: 25),
              ),
              SizedBox(width: 95),
              Text("126",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text("drops",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal)),
              ),
              SizedBox(width: 10),
              Text("83",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text("replies",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal)),
              ),
              SizedBox(width: 10),
              Text("200",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              SizedBox(width: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text("views",
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal)),
              ),
            ])),
          ]),
        ]);
  }

  @override
  Widget build(BuildContext context){
    String comment = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi congue felis ut elit dictum tincidunt. In nec orci. Phasellus at nisi vitae lorem feugiat interdum. Curabitur ultricies odio eu dolor efficitur, sit amet pretium sem elementum.";

    double appbar_h = MediaQuery.of(context).size.height * 0.08;
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    double textfield_icon_size = screen_width * 0.06;
    return new Scaffold(
      appBar: PreferredSize
      (
        preferredSize: Size.fromHeight(appbar_h) ,
        child: AppBar(
        leading: new Row(children:[
          SizedBox(width: 20,),
          Column(children:
          [
             SizedBox(height: 20,),
             Text('Comment', style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.bold))
          ])
        ]),      
        leadingWidth: 500,      
        backgroundColor: Colors.white,
      )),
      body:Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        color: Colors.white,
        child:ListView(children: [
             Row(children: [
              Column(
                  children: [
                    SizedBox(height: 5,),
                    Container(
                        height: 50,
                        width: 346,
                        padding: const EdgeInsets.fromLTRB(5, 2, 0, 10),
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Color(0xffF2F2F7),
                            filled: true,
                            hintText: 'Add a public comment...',
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
                  onPressed: () {},
                  child: const Text('Post', style:TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
        _ForumCard("Gloria Schultz", 'assets/profile_pic.png', 'assets/forum_pic.png',"Towradgi Beach", "2",comment ),
        SizedBox(height: 2,),
        _ForumCard("Sergiu Iacob", 'assets/profile_pic2.png', 'assets/forum_pic.png',"Towradgi Beach", "5",comment ),
        SizedBox(height: 2,),
        _ForumCard("Nathen Mcneil", 'assets/profile_pic3.png', 'assets/forum_pic.png',"Towradgi Beach", "1",comment ),
        SizedBox(height: 2,),
        _ForumCard("Terrell Lam", 'assets/profile_pic4.png', 'assets/forum_pic.png',"Towradgi Beach", "4",comment ),
        SizedBox(height: 2,),
        _ForumCard("Pranav Deleon", 'assets/profile_pic5.png', 'assets/forum_pic.png',"Towradgi Beach", "5",comment ),
        SizedBox(height: 2,),
        _ForumCard("Guadalupe Avila", 'assets/profile_pic6.png', 'assets/forum_pic.png',"Towradgi Beach", "6",comment ),
        SizedBox(height: 2,),
        _ForumCard("Annabella Petersen", 'assets/profile_pic7.png', 'assets/forum_pic.png',"Towradgi Beach", "5", comment),
        SizedBox(height: 2,),
        _ForumCard("Svarog Edortas", 'assets/profile_pic.png', 'assets/forum_pic.png',"Towradgi Beach", "15",comment ),
        SizedBox(height: 2,),
        _ForumCard("Elene Líadan", 'assets/profile_pic2.png', 'assets/forum_pic.png',"Towradgi Beach", "9",comment ),
      ],)
   )
   );
  }

}



