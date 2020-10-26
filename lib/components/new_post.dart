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
import 'package:wesurf/backend/location_data.dart';

class CreateNewPost extends StatefulWidget {
  CreateNewPost(this.locationUID);
  final String locationUID;
  // @override
  CreateNewPostState createState() => CreateNewPostState();
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
     String selected_how_mood = "empty";
  String selected_surf_mood = "empty";
  String selected_wave_mood = "empty";
  String selected_wind_mood = "empty";
  String selected_crowd_mood = "empty";

 
  bool how_happy_stat = false;
  bool how_sad_stat = false;
  bool how_neutral_stat = false;
  bool surf_happy_stat = false; 
  bool surf_sad_stat = false;
   bool surf_neutral_stat = false;
  bool wave_happy_stat = false;
  bool wave_sad_stat = false;
  bool wave_neutral_stat = false; 
  bool wind_sad_stat = false;
   bool wind_happy_stat = false;
  bool wind_neutral_stat = false;
  bool crowd_happy_stat = false;
  bool crowd_sad_stat = false; 
  bool crowd_neutral_stat = false;

  String how_happy = "how_happy"; 
  String how_sad = "how_sad";
  String how_neutral = "how_neutral";
  String surf_happy="surf_happy";
  String surf_sad = "surf_sad";
  String surf_neutral= "surf_neutral";
  String wave_happy="wave_happy";
  String wave_sad="wave_sad";
  String wave_neutral="wave_neutral";
  String wind_happy="wind_happy";
  String wind_sad="wind_sad";
  String wind_neutral="wind_neutral";
  String crowd_happy = "crowd_happy";
  String crowd_sad="crowd_sad";
  String crowd_neutral="crowd_neutral";

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
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                textColor: Color(0xFF1A7EFF),
                child: Row(children: [
                  Text('Post',
                      style: TextStyle(
                          color: Color(0xFF1276FF),
                          fontWeight: FontWeight.w700))
                ]),
              ),
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

  Widget _conditionIcon(IconData icon, Color color, final ValueNotifier<bool> moodPressed, bool btnStat, String btnType) 
  {
    bool Clickable  = false;

    return GestureDetector
    (
      child: Container(
        child: new Icon(
          icon,
          size: 23,
          color: moodPressed.value ? color : Colors.black,
      )),
      onTap: () 
      {
        setState(() 
        {
            if(btnType=="how_happy")
            {
              how_happyClick.value = true;
              how_neutralClick.value = false;
              how_sadClick.value = false;
              selected_how_mood = "happy";
            
            }else if(btnType=="how_sad")
            { 
              how_sadClick.value = true;
              how_neutralClick.value = false;
              how_happyClick.value = false;
              selected_how_mood = "sad";
             
            }else if(btnType=="how_neutral")
            {
              how_sadClick.value = false;
              how_neutralClick.value = true;
              how_happyClick.value = false;
              selected_how_mood = "neutral";
            }

            if(btnType=="surf_happy")
            {
              surf_sadClick.value = false;
              surf_neutralClick.value = false;
              surf_happyClick.value = true;
              selected_surf_mood = "happy";
            }else if(btnType=="surf_sad")
            { 
              surf_sadClick.value = true;
              surf_neutralClick.value = false;
              surf_happyClick.value = false;
              selected_surf_mood = "sad";
            }else if(btnType=="surf_neutral")
            {
              surf_sadClick.value = false;
              surf_neutralClick.value = true;
              surf_happyClick.value = false;
              selected_surf_mood = "neutral";
            }

            if(btnType=="wave_happy")
            {
              wave_sadClick.value = false;
              wave_neutralClick.value = false;
              wave_happyClick.value = true;
              selected_wave_mood = "happy";
            }else if(btnType=="wave_sad")
            { 
              wave_sadClick.value = true;
              wave_neutralClick.value = false;
              wave_happyClick.value = false;
              selected_wave_mood = "sad";
            }else if(btnType=="wave_neutral")
            {
              wave_sadClick.value = false;
              wave_neutralClick.value = true;
              wave_happyClick.value = false;
              selected_wave_mood = "neutral";
            }

             if(btnType=="wind_happy")
            {
              wind_sadClick.value = false;
              wind_neutralClick.value = false;
              wind_happyClick.value = true;
              selected_wind_mood = "happy";
            }else if(btnType=="wind_sad")
            { 
              wind_sadClick.value = true;
              wind_neutralClick.value = false;
              wind_happyClick.value = false;
              selected_wind_mood = "sad";
            }else if(btnType=="wind_neutral")
            {
              wind_sadClick.value = false;
              wind_neutralClick.value = true;
              wind_happyClick.value = false;
              selected_wind_mood = "neutral";
            }

             if(btnType=="crowd_happy")
            {
              crowd_sadClick.value = false;
              crowd_neutralClick.value = false;
              crowd_happyClick.value = true;
              selected_crowd_mood = "happy";
            }else if(btnType=="crowd_sad")
            { 
              crowd_sadClick.value = true;
              crowd_neutralClick.value = false;
              crowd_happyClick.value = false;
              selected_crowd_mood = "sad";
            }else if(btnType=="crowd_neutral")
            {
              crowd_sadClick.value = false;
              crowd_neutralClick.value = true;
              crowd_happyClick.value = false;
              selected_crowd_mood = "neutral";
            }

            print("selected_how_mood: " + selected_how_mood);
            print("selected_surf_mood: " + selected_surf_mood);
            print("selected_wave_mood: " + selected_wave_mood);
            print("selected_wind_mood: " + selected_wind_mood);
            print("selected_crowd_mood: " + selected_crowd_mood);
        });
      }      
      );
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
               child: _conditionIcon( TablerIcons.mood_happy, Color(0XFF52DB69), how_happyClick,how_happy_stat, how_happy,),
            )),
            TableCell(
                child: Center(
              child: _conditionIcon(
                   TablerIcons.mood_neutral, Color(0XFFFE9E12), how_neutralClick,how_neutral_stat,how_neutral),
            )),
            TableCell(
                child: Center(
              child: _conditionIcon(
                  TablerIcons.mood_neutral, Colors.redAccent, how_sadClick,how_sad_stat,how_sad),

            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Surf condition\n")),
            TableCell(
                child: Center(
                  child: _conditionIcon( TablerIcons.mood_happy, Color(0XFF52DB69), surf_happyClick,surf_happy_stat, surf_happy,),
            )),
            TableCell(
                child: Center(
                  child: _conditionIcon( TablerIcons.mood_neutral, Color(0XFFFE9E12), surf_neutralClick,surf_neutral_stat, surf_neutral,),
            )),
            TableCell(
                child: Center(
                  child: _conditionIcon( TablerIcons.mood_sad,Colors.redAccent, surf_sadClick,surf_sad_stat, surf_sad,),
            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Wave height\n")),
            TableCell(
                child: Center(
                  child: _conditionIcon( TablerIcons.mood_happy,Color(0XFF52DB69), wave_happyClick,wave_happy_stat, wave_happy,),
            )),
            TableCell(
                child: Center(
                    child: _conditionIcon( TablerIcons.mood_neutral,Color(0XFFFE9E12), wave_neutralClick,wave_neutral_stat, wave_neutral,),
            )),
            TableCell(
                child: Center(
                    child: _conditionIcon( TablerIcons.mood_sad,Colors.redAccent, wave_sadClick,wave_sad_stat, wave_sad,),
            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Wind speed\n")),
            TableCell(
                child: Center(
                  child: _conditionIcon( TablerIcons.mood_happy,Color(0XFF52DB69), wind_happyClick,wind_happy_stat, wind_happy,),
            )),
            TableCell(
                child: Center(
                   child: _conditionIcon( TablerIcons.mood_neutral,Color(0XFFFE9E12), wind_neutralClick,wind_neutral_stat, wind_neutral,),
            )),
            TableCell(
                child: Center(
                   child: _conditionIcon( TablerIcons.mood_sad,Colors.redAccent, wind_sadClick,wind_sad_stat, wind_sad,),

            )),
          ]),
          TableRow(children: [
            TableCell(child: _conditionText("Crowd level\n")),
            TableCell(
                child: Center(
                    child: _conditionIcon( TablerIcons.mood_happy,Color(0XFF52DB69), crowd_happyClick,crowd_happy_stat, crowd_happy,),
            )),
            TableCell(
                child: Center(
                    child: _conditionIcon( TablerIcons.mood_neutral,Color(0XFFFE9E12), crowd_neutralClick,crowd_neutral_stat, crowd_neutral,),
            )),
            TableCell(
                child: Center(
                    child: _conditionIcon( TablerIcons.mood_sad,Colors.redAccent, crowd_sadClick,crowd_sad_stat, crowd_sad,),
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
            debugPrint("Post button clicked");
            _postBtn();
          });
        },
      ),
    );
  }

  Future _getImage1() async {
    image1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image1 = image1;
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

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of todo object
  void updateTitle() {
    //forumPost.username = contentsController.text;
  }

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
    LocationData locationData = new LocationData(locationUID: widget.locationUID);
    PostData postData = new PostData();
    String postUID = await postData.createPost(userUID, widget.locationUID, contentsController.text, imageURL, mood);
    locationData.addPost(postUID);

    Navigator.pop(context, true);
  }

  void _cancelBtn() async {
    Navigator.pop(context, true);
}
}