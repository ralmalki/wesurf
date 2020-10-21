import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import 'package:wesurf/backend/post_data.dart';

class CreateNewPost extends StatefulWidget {
  CreateNewPost(this.locationUID);
  final String locationUID;

  @override
  CreateNewPostState createState() => CreateNewPostState();

  String upload_pic_path;
  String post_contents;
  String surf_condition;
  String wave_height;
  String wind_speed;
  String crowd_level;
}

class CreateNewPostState extends State<CreateNewPost> {
  dynamic _image1, _image2, _image3, _image4, _image5, _image6;
  var image1, image2, image3, image4, image5, image6;

  File testImage;
  String mood;

  TextEditingController contentsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String upload_pic_path;
  String post_contents;
  String surf_condition;
  String wave_height;
  String wind_speed;
  String crowd_level;

  final ValueNotifier<bool> how_happyClick = ValueNotifier(false);
  final ValueNotifier<bool> how_sadClick = ValueNotifier(false);
  final ValueNotifier<bool> how_neutralClick = ValueNotifier(false);

  final ValueNotifier<bool> surf_happyClick = ValueNotifier(false);
  final ValueNotifier<bool> surf_sadClick = ValueNotifier(false);
  final ValueNotifier<bool> surf_neutralClick = ValueNotifier(false);

  final ValueNotifier<bool> wave_happyClick = ValueNotifier(false);
  final ValueNotifier<bool> wave_sadClick = ValueNotifier(false);
  final ValueNotifier<bool> wave_neutralClick = ValueNotifier(false);

  final ValueNotifier<bool> wind_happyClick = ValueNotifier(false);
  final ValueNotifier<bool> wind_sadClick = ValueNotifier(false);
  final ValueNotifier<bool> wind_neutralClick = ValueNotifier(false);

  final ValueNotifier<bool> crowd_happyClick = ValueNotifier(false);
  final ValueNotifier<bool> crowd_sadClick = ValueNotifier(false);
  final ValueNotifier<bool> crowd_neutralClick = ValueNotifier(false);

  ValueNotifier<bool> isSelect = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: new AppBar(
            title: new Text('Create New Post',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
            // leading: new Row(children: [
            //   FlatButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     textColor: Color(0xFF1A7EFF),
            //     child: Row(children: [
            //       Icon(
            //         Icons.arrow_back_ios,
            //         size: 17,
            //         color: Color(0xFFFF1300),
            //       ),
            //       SizedBox(
            //         width: 5,
            //       ),
            //       Text('Back',
            //           style: TextStyle(
            //               color: Color(0xFFFC2D54),
            //               fontWeight: FontWeight.w700))
            //     ]),
            //   ),
            // ]),
            //leadingWidth: 90,
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: <Widget>[
              _PostBtn()
              // FlatButton(
              //   onPressed: () {
              //     // Navigator.pop(context);
              //   },
              //   textColor: Color(0xFF1A7EFF),
              //   child: Row(children: [
              //     Text('Post',
              //         style: TextStyle(
              //             color: Color(0xFF1276FF),
              //             fontWeight: FontWeight.w700))
              //   ]),
              // ),
            ],
          ),
          body: Container(
              color: Color(0xFFF2F2F7),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(children: <Widget>[
                _textarea(),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _uploadImage1(),
                      SizedBox(width: 10),
                      _uploadImage2(),
                      SizedBox(width: 10),
                      _uploadImage3(),
                    ]),
                SizedBox(
                  height: 15,
                ),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _uploadImage4(),
                      SizedBox(width: 10),
                      _uploadImage5(),
                      SizedBox(width: 10),
                      _uploadImage6(),
                    ]),
                SizedBox(
                  height: 5,
                ),
                _beachInfo("Towradgi Beach"),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  _surfConditionTable(),
                ]),
              ]))),
    );
  }

  Widget _beachInfo(String beach_info) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //SizedBox(width:12),
              Icon(
                TablerIcons.map_pin,
                color: Color(0xFF1276FF),
              ),
              SizedBox(width: 5),
              Text(beach_info,
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1276FF),
                      fontWeight: FontWeight.w500))
            ]));
  }

  Widget _textarea() {
    return Container(
        height: 80,
        child: TextField(
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          controller: contentsController,
          decoration: InputDecoration(
              hintText: "Say something...",
              hintStyle: TextStyle(fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              alignLabelWithHint: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFECECEC), width: 1.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
          onChanged: (text) {
            setState(() {});
          },
        ));
  }

  Widget _conditionIcon(
      IconData icon, Color color, final ValueNotifier<bool> moodPressed, {String moodIcon}) {
    return ValueListenableBuilder(
        valueListenable: moodPressed,
        builder: (context, bool pressed, child) {
          return GestureDetector(
            onTap: () {
              setState(() {
                moodPressed.value = !moodPressed.value;
                if (moodIcon != null) {
                  mood = moodIcon;
                }
                print(mood);
              });
            },
            child: Container(
              child: new Icon(
                icon,
                size: 23,
                color: moodPressed.value ? color : Colors.black,
              ),
            ),
          );
        });
  }

  Widget _conditionsBtn(String btnStr, int btnColor, double btnWidth) {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5, top: 10),
        child: SizedBox(
          width: 70,
          height: 30,
          child: RaisedButton(
            onPressed: () {
              print('Button Clicked');
            },
            child: Text(btnStr),
            color: Colors.white,
            textColor: Color(btnColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: Color(btnColor),
                  width: 1,
                )),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          ),
        ));
  }

  Widget _conditionText(String str) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(str,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              //fontWeight: FontWeight.w500
            )));
  }

  Widget _surfConditionTable() {
    return Container(
      width: 370,
      padding: EdgeInsets.only(
        left: 18,
        top: 15,
      ),
      child: Table(
        defaultColumnWidth: FixedColumnWidth(89),
        border: TableBorder.all(
            color: Colors.black26, width: 1, style: BorderStyle.none),
        children: [
          TableRow(children: [
            TableCell(
                child: Row(
              children: [
                _conditionText("How was it \n"),
                Text("*\n",
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            )),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_happy, Color(0XFF52DB69), how_happyClick, moodIcon: 'mood_happy'),
            )),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_neutral, Color(0XFFFE9E12), how_sadClick, moodIcon: 'mood_neutral'),
            )),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_sad, Colors.redAccent, how_neutralClick, moodIcon: 'mood_sad'),
            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Surf condition\n")),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_happy, Color(0XFF52DB69), surf_happyClick),
            )),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_neutral, Color(0XFFFE9E12), surf_sadClick),
            )),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_sad, Colors.redAccent, surf_neutralClick),
            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Wave height\n")),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_happy, Color(0XFF52DB69), wave_happyClick),
            )),
            TableCell(
                child: Center(
                    child: _conditionIcon(TablerIcons.mood_neutral,
                        Color(0XFFFE9E12), wave_sadClick))),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_sad, Colors.redAccent, wave_neutralClick),
            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Wind speed\n")),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_happy, Color(0XFF52DB69), wind_happyClick),
            )),
            TableCell(
                child: Center(
                    child: _conditionIcon(TablerIcons.mood_neutral,
                        Color(0XFFFE9E12), wind_sadClick))),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_sad, Colors.redAccent, wind_neutralClick),
            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Crowd level\n")),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_happy, Color(0XFF52DB69), crowd_happyClick),
            )),
            TableCell(
                child: Center(
                    child: _conditionIcon(TablerIcons.mood_neutral,
                        Color(0XFFFE9E12), crowd_sadClick))),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_sad, Colors.redAccent, crowd_neutralClick),
            )),
          ]),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget _CancelBtn() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
      child: RaisedButton(
        color: Color(0xFF003A73),
        textColor: Colors.white,
        child: Text(
          'Cancel',
          textScaleFactor: 1.2,
        ),
        onPressed: () {
          setState(() {
            debugPrint("Delete button clicked");
            _cancelBtn();
          });
        },
      ),
    );
  }

  Widget _PostBtn() {
    return Padding(
      // padding: EdgeInsets.fromLTRB(150, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
      child: RaisedButton(
        color: Color(0xFF003A73),
        textColor: Colors.white,
        child: Text(
          'Post',
          textScaleFactor: 1.2,
        ),
        onPressed: () {
          setState(() {
            print("Post button clicked");
            _postBtn();
          });
          // _postBtn();
        },
      ),
    );
  }

  Future _getImage1() async {
    image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image1 = image1;
      //testImage = File(_image1);
    });
  }

  Future _getImage2() async {
    image2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image2 = image2;
    });
  }

  Future _getImage3() async {
    image3 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image3 = image3;
    });
  }

  Future _getImage4() async {
    image4 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image4 = image4;
    });
  }

  Future _getImage5() async {
    image5 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image5 = image5;
    });
  }

  Future _getImage6() async {
    image6 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image6 = image6;
    });
  }

  Widget _uploadImage1() {
    return Expanded(
        child: new Align(
            child: new Container(
      width: 110.0,
      height: 105,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF003A73),
            width: 1.2,
          )),
      child: new GestureDetector(
        onTap: () {
          _getImage1();
        },
        child: new Stack(alignment: Alignment.topRight, children: <Widget>[
          new ConstrainedBox(
            child: _image1 == null
                ? new Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Color(0xFF003A73),
                  )
                : new Stack(alignment: Alignment.topRight, children: <Widget>[
                    new ConstrainedBox(
                      child: new Image.file(_image1, fit: BoxFit.cover),
                      constraints: BoxConstraints.expand(),
                    ),
                    new GestureDetector(
                      child: new Icon(
                        TablerIcons.x,
                        size: 20,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _image1 = null;
                        });
                      },
                    )
                  ]),
            constraints: BoxConstraints.expand(),
          ),
        ]),
      ),
    )));
  }

  Widget _uploadImage2() {
    return Expanded(
        child: new Align(
            child: new Container(
      width: 110.0,
      height: 105,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF003A73),
            width: 1.2,
          )),
      child: new GestureDetector(
        onTap: () {
          _getImage2();
        },
        child: new Stack(alignment: Alignment.topRight, children: <Widget>[
          new ConstrainedBox(
            child: _image2 == null
                ? new Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Color(0xFF003A73),
                  )
                : new Stack(alignment: Alignment.topRight, children: <Widget>[
                    new ConstrainedBox(
                      child: new Image.file(_image2, fit: BoxFit.cover),
                      constraints: BoxConstraints.expand(),
                    ),
                    new GestureDetector(
                      child: new Icon(
                        TablerIcons.x,
                        size: 20,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _image2 = null;
                        });
                      },
                    )
                  ]),
            constraints: BoxConstraints.expand(),
          ),
        ]),
      ),
    )));
  }

  Widget _uploadImage3() {
    return Expanded(
        child: new Align(
            child: new Container(
      width: 110.0,
      height: 105,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF003A73),
            width: 1.2,
          )),
      child: new GestureDetector(
        onTap: () {
          _getImage3();
        },
        child: new Stack(alignment: Alignment.topRight, children: <Widget>[
          new ConstrainedBox(
            child: _image3 == null
                ? new Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Color(0xFF003A73),
                  )
                : new Stack(alignment: Alignment.topRight, children: <Widget>[
                    new ConstrainedBox(
                      child: new Image.file(_image3, fit: BoxFit.cover),
                      constraints: BoxConstraints.expand(),
                    ),
                    new GestureDetector(
                      child: new Icon(
                        TablerIcons.x,
                        size: 20,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _image3 = null;
                        });
                      },
                    )
                  ]),
            constraints: BoxConstraints.expand(),
          ),
        ]),
      ),
    )));
  }

  Widget _uploadImage4() {
    return Expanded(
        child: new Align(
            child: new Container(
      width: 110.0,
      height: 105,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF003A73),
            width: 1.2,
          )),
      child: new GestureDetector(
        onTap: () {
          _getImage4();
        },
        child: new Stack(alignment: Alignment.topRight, children: <Widget>[
          new ConstrainedBox(
            child: _image4 == null
                ? new Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Color(0xFF003A73),
                  )
                : new Stack(alignment: Alignment.topRight, children: <Widget>[
                    new ConstrainedBox(
                      child: new Image.file(_image4, fit: BoxFit.cover),
                      constraints: BoxConstraints.expand(),
                    ),
                    new GestureDetector(
                      child: new Icon(
                        TablerIcons.x,
                        size: 20,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _image4 = null;
                        });
                      },
                    )
                  ]),
            constraints: BoxConstraints.expand(),
          ),
        ]),
      ),
    )));
  }

  Widget _uploadImage5() {
    return Expanded(
        child: new Align(
            child: new Container(
      width: 110.0,
      height: 105,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF003A73),
            width: 1.2,
          )),
      child: new GestureDetector(
        onTap: () {
          _getImage5();
        },
        child: new Stack(alignment: Alignment.topRight, children: <Widget>[
          new ConstrainedBox(
            child: _image5 == null
                ? new Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Color(0xFF003A73),
                  )
                : new Stack(alignment: Alignment.topRight, children: <Widget>[
                    new ConstrainedBox(
                      child: new Image.file(_image5, fit: BoxFit.cover),
                      constraints: BoxConstraints.expand(),
                    ),
                    new GestureDetector(
                      child: new Icon(
                        TablerIcons.x,
                        size: 20,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _image5 = null;
                        });
                      },
                    )
                  ]),
            constraints: BoxConstraints.expand(),
          ),
        ]),
      ),
    )));
  }

  Widget _uploadImage6() {
    return Expanded(
        child: new Align(
            child: new Container(
      width: 110.0,
      height: 105,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF003A73),
            width: 1.2,
          )),
      child: new GestureDetector(
        onTap: () {
          _getImage6();
        },
        child: new Stack(alignment: Alignment.topRight, children: <Widget>[
          new ConstrainedBox(
            child: _image6 == null
                ? new Icon(
                    Icons.add_a_photo,
                    size: 30,
                    color: Color(0xFF003A73),
                  )
                : new Stack(alignment: Alignment.topRight, children: <Widget>[
                    new ConstrainedBox(
                      child: new Image.file(_image6, fit: BoxFit.cover),
                      constraints: BoxConstraints.expand(),
                    ),
                    new GestureDetector(
                      child: new Icon(
                        TablerIcons.x,
                        size: 20,
                        color: Colors.white,
                      ),
                      onTap: () {
                        setState(() {
                          _image6 = null;
                        });
                      },
                    )
                  ]),
            constraints: BoxConstraints.expand(),
          ),
        ]),
      ),
    )));
  }

  // void moveToLastScreen() {
  //   Navigator.pop(context, true);
  // }

  // // Update the title of todo object
  // void updateTitle() {
  //   //forumPost.username = contentsController.text;
  // }

  // Save data to database
  void _postBtn() async {
    await Firebase.initializeApp();

    //-----testing
    String fileName = path.basename(image1.path);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image1);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var url  = await taskSnapshot.ref.getDownloadURL();
    String imageURL = url.toString();
    // taskSnapshot.ref.getDownloadURL().then(
    //     (value) => imageURL = value
    // );
    print(imageURL);

    //----------------
    String userUID = FirebaseAuth.instance.currentUser.uid;
    PostData postData = new PostData(locationUID: widget.locationUID);
    String postUID = await postData.createPost(userUID, contentsController.text, imageURL, mood);
    postData.addPost(postUID);

    Navigator.pop(context, true);
  }

  void _cancelBtn() async {
    Navigator.pop(context, true);
  }
}
