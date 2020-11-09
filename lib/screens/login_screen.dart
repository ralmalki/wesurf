import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wesurf/screens/home.dart';
import 'package:wesurf/screens/register_screen.dart';
import 'package:wesurf/components/onboarding.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:wesurf/backend/user_data.dart';
import 'map_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new MaterialApp(
      // title: 'CurvedShape',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new MyHomePage(title: 'CurvedShape'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController =
      TextEditingController(text: "hayden@me.com");
  TextEditingController passwordController =
      TextEditingController(text: "123456");
  bool isChecked = false;
  var resultHolder = 'Checkbox is UN-CHECKED';
  PageController _pageController = PageController();

  Future<void> showAlertDialog(
      BuildContext context, String title, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F7),
      body: new Stack(
        children: [
          Container(
            child: ClipPath(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                color: Color(0xFF1276FF),
              ),
              clipper: CustomClipPath(),
            ),
          ),
          Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.012,
                top: MediaQuery.of(context).size.height * 0.09,
              ),
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/icon.png',
                  scale: MediaQuery.of(context).size.width * 0.004,
                ),
              )),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    double form_height = MediaQuery.of(context).size.height * 0.285;
    double form_padding_left = screen_width * 0.036;

    double label_padding_top = screen_height * 0.011; //10
    double label_padding_bottom = screen_height * 0.0065; //5

    double textfield_icon_size = screen_width * 0.06;
    double textfield_padding_top = screen_height * 0.02;

    return Container(
      padding: EdgeInsets.fromLTRB(
          form_padding_left, form_height, form_padding_left, 0),
      child:
          ListView(physics: NeverScrollableScrollPhysics(), children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(form_padding_left, label_padding_top,
              form_padding_left, label_padding_bottom),
          child: Text(
            'Get Surfing With WeSurf',
            style: TextStyle(
                fontFamily: 'sans serif',
                fontWeight: FontWeight.w700,
                fontSize: 25),
          ),
        ),
        _textfield('Username', nameController, form_padding_left,
            Icons.person_outline, textfield_icon_size, textfield_padding_top,
            isPassword: false),
        _textfield(
          'Password',
          passwordController,
          form_padding_left,
          Icons.lock_outline,
          textfield_icon_size - 2,
          textfield_padding_top,
          isPassword: true,
        ),
        _checkbox('Remember me'),
        _logInBtn('Log In', form_padding_left),
        _divider('OR', form_padding_left),
        _fbLoginInBtn('Log in with Facebook', form_padding_left),
        _signUp(),
      ]),
    );
  }

  Widget _textfield(
      String labelString,
      TextEditingController textfieldController,
      double form_padding_left,
      IconData iconType,
      double iconSize,
      double padding_top,
      {bool isPassword = false}) {
    return new Container(
      padding: EdgeInsets.fromLTRB(
          form_padding_left, padding_top, form_padding_left, 5),
      child: new TextField(
        style: TextStyle(height: 0.5, color: Colors.black),
        controller: textfieldController,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconType,
            size: iconSize,
          ),
          fillColor: Colors.white,
          filled: true,
          labelText: labelString,
          labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xffB0B0B8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void toggleCheckbox(bool value) {
    if (isChecked == false) {
      setState(() {
        isChecked = true;
        resultHolder = 'Checkbox is CHECKED';
      });
    } else {
      setState(() {
        isChecked = false;
        resultHolder = 'Checkbox is UN-CHECKED';
      });
    }
  }

  Widget _checkbox(String checkboxLable) {
    bool _isChecked = false;
    String _currText = '';
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 3),
          child: Checkbox(
            value: isChecked,
            onChanged: (value) {
              toggleCheckbox(value);
            },
            activeColor: Color(0xFF1276FF),
            checkColor: Colors.white,
            tristate: false,
          ),
        ),
        Container(
          // padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            checkboxLable,
            style: TextStyle(
              color: Color(0xFF3D3D3D),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        FlatButton(
          padding: const EdgeInsets.only(left: 107),
          onPressed: () {
            //forgot password screen
          },
          textColor: Colors.grey[500],
          child: Text('Forgot Password',
              style: TextStyle(fontWeight: FontWeight.w400)),
        ),
      ],
    );
  }

  Widget _logInBtn(String btnStr, double form_padding_left) {
    double padding_top = MediaQuery.of(context).size.height * 0.02;
    double btn_height = MediaQuery.of(context).size.height * 0.07;
    return Container(
        height: btn_height,
        padding: EdgeInsets.fromLTRB(
            form_padding_left, padding_top, form_padding_left, 0),
        child: RaisedButton(
            textColor: Colors.white,
            color: Color(0xFFFE2D55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              btnStr,
            ),
            /*
          onPressed: () {
            print(nameController.text);
            print(passwordController.text);
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },*/
            onPressed: () async {
              //await Firebase.initializeApp();
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: nameController.text,
                        password: passwordController.text);
                if (userCredential != null) {
                  User user = userCredential.user;
                  print(user.metadata.lastSignInTime);
                  //_pageController.jumpToPage(3);
                  bool firstTime = true;
                  await UserData(uid: FirebaseAuth.instance.currentUser.uid)
                    .firstTime()
                    .then((value) {
                      firstTime = value;
                  });
                  if (firstTime)
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => OnBoarding(user: user)));
                  else
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Home()));
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-notfound') {
                  showAlertDialog(context, "Account not found",
                      "If you don't have an account, try to create on");
                  print('No user found for that email');
                } else if (e.code == 'wrong-password') {
                  showAlertDialog(
                      context, "Error", "Email/Password dose not match!");
                  print("Wrong password provided by user");
                }
              }
            }));
  }

  Widget _fbLoginInBtn(String btnStr, double form_padding_left) {
    double padding_top = MediaQuery.of(context).size.height * 0.022;
    double btn_height = MediaQuery.of(context).size.height * 0.078;
    double space_btw = MediaQuery.of(context).size.width * 0.14;
    return Container(
        height: btn_height,
        padding: EdgeInsets.fromLTRB(
            form_padding_left, padding_top, form_padding_left, 0),
        child: FlatButton(
          child: Row(children: <Widget>[
            Image.asset('assets/facebookIcon.png'),
            SizedBox(width: space_btw),
            Text(btnStr),
          ]),
          textColor: Colors.white,
          color: Color(0xFF344D8B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            // print(nameController.text);
            //print(passwordController.text);
          },
        ));
  }

  Widget _divider(String str, double form_padding_left) {
    double padding_top = MediaQuery.of(context).size.height * 0.022;
    double d1_padding_right = MediaQuery.of(context).size.width * 0.06;

    return Container(
      padding: EdgeInsets.only(
        top: padding_top,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: form_padding_left, right: d1_padding_right),
              child: Divider(
                color: Colors.grey[500],
                thickness: 0.3,
              ),
            ),
          ),
          Text(
            str,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: d1_padding_right, right: form_padding_left),
              child: Divider(
                color: Colors.grey[500],
                thickness: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUp() {
    double pad_left = MediaQuery.of(context).size.width * 0.17;
    double pad_top = MediaQuery.of(context).size.height * 0.0056;
    return Container(
        padding: EdgeInsets.only(left: pad_left, top: pad_top),
        child: Row(children: <Widget>[
          Text("Doesn't have an account?",
              style: TextStyle(fontFamily: 'sans serif')),
          FlatButton(
            // padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Register()));
            },
            textColor: Color(0xFF1A7EFF),
            child:
                Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 190); //bottom left
    path.quadraticBezierTo(size.width / 1.9, size.height - 140, size.width,
        size.height - 190); //2th: lowest point, 4th:bottom right
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
