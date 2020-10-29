import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wesurf/backend/user_data.dart';
import 'package:wesurf/components/onboarding.dart';

import 'home.dart';
import 'login_screen.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new MaterialApp(
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
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
    double widget_padding_left = MediaQuery.of(context).size.width * 0.036;
    double form_height = MediaQuery.of(context).size.height;
    double create_account_padding_top =
        MediaQuery.of(context).size.height / 3.4;
    double create_account_padding_bottom = form_height * 0.002;
    double textfields_padding_bottom = form_height * 0.02;
    double icon_size = form_height * 0.025;
    double have_account_padding_left = form_height * 0.078;

    return Container(
      padding: EdgeInsets.fromLTRB(
          widget_padding_left * 2,
          create_account_padding_top,
          widget_padding_left * 2,
          create_account_padding_bottom),
      width: MediaQuery.of(context).size.width,
      child:
          ListView(physics: NeverScrollableScrollPhysics(), children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: create_account_padding_bottom),
          child: Text(
            'Create Account',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ),
        _textfield('Username', nameController, Icons.person_outline,
            icon_size + 2, textfields_padding_bottom),
        _textfield('Email', emailController, Icons.mail_outline, icon_size,
            textfields_padding_bottom),
        _textfield(
          'Password',
          passwordController,
          Icons.lock_outline,
          icon_size,
          textfields_padding_bottom,
          isPassword: true,
        ),
        _textfield('Confirm Password', confirmPasswordController,
            Icons.lock_outline, icon_size, textfields_padding_bottom,
            isPassword: true, padding_bottom: 20),
        _logInBtn('Sign Up'),
        _divider('OR'),
        _fbLoginInBtn('Sign up with Facebook'),
        _signIn(have_account_padding_left)
      ]),
    );
  }

  Widget _textfield(
    String labelString,
    TextEditingController textfieldController,
    IconData iconType,
    double iconSize,
    double padding_top, {
    bool isPassword = false,
    double padding_bottom = 0,
  }) {
    double widget_padding_left = MediaQuery.of(context).size.width * 0.036;

    return new Container(
      padding: EdgeInsets.only(top: padding_top, bottom: padding_bottom),
      child: new TextField(
        style: TextStyle(height: 0.5, color: Colors.black),
        controller: textfieldController,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconType,
            size: iconSize,
            color: Colors.black,
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

  Widget _logInBtn(String btnStr) {
    //Firebase.initializeApp();
    double padding_top = MediaQuery.of(context).size.width * 0.0056;
    return Container(
        height: MediaQuery.of(context).size.height * 0.055,
        padding: EdgeInsets.only(
          top: padding_top,
        ),
        child: RaisedButton(
          textColor: Colors.white,
          color: Color(0xFFFE2D55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            btnStr,
          ),
          onPressed: () async {
            print(nameController.text);
            print(emailController.text);
            print(passwordController.text);
            try {
              if (passwordController.text != confirmPasswordController.text) {
                throw Exception("confirm password not match");
              }
              UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text);
              User user = userCredential.user;

              // UserData newUser = UserData(uid: user.uid)
              //     .updateOrAddUserName(nameController.text);
              await UserData(uid: user.uid)
                  .updateOrAddUserName(nameController.text);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OnBoarding()));
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('The password is weak');
                return;
              } else if (e.code == 'email-already-in-use') {
                print('The account already existed');
                return;
              }
            } catch (e) {
              print(e.toString());
              return;
            }

            //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ));
  }

  Widget _fbLoginInBtn(String btnStr) {
    double padding_top = MediaQuery.of(context).size.height * 0.022;
    return Container(
        height: MediaQuery.of(context).size.height * 0.075,
        padding: EdgeInsets.only(
          top: padding_top,
        ),
        child: FlatButton(
          child: Row(children: <Widget>[
            Image.asset('assets/facebookIcon.png'),
            SizedBox(width: 70),
            Text(btnStr),
          ]),
          textColor: Colors.white,
          color: Color(0xFF344D8B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {},
        ));
  }

  Widget _divider(String str) {
    double padding_top = MediaQuery.of(context).size.height * 0.028;
    double padding_left = MediaQuery.of(context).size.width * 0.06;
    double padding_right = MediaQuery.of(context).size.width * 0.009;
    return Container(
      padding: EdgeInsets.only(
        top: padding_top,
      ),
      //margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: padding_left),
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
              padding:
                  EdgeInsets.only(left: padding_left, right: padding_right),
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

  Widget _signIn(double have_account_padding_left) {
    return Container(
        padding: EdgeInsets.only(left: have_account_padding_left),
        child: Row(children: <Widget>[
          Text("Already have an account?"),
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            textColor: Color(0xFF1A7EFF),
            child:
                Text('Log In', style: TextStyle(fontWeight: FontWeight.w700)),
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
