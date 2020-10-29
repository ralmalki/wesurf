import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wesurf/screens/home.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({this.user});
  final User user;

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final String lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
            child: AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.grey,
                title: Image.asset('assets/Logo-Blue.png',
                    height: MediaQuery.of(context).size.height * 0.055)),
          ),
          body: IntroductionScreen(
              globalBackgroundColor: Colors.white60,
              animationDuration: 400,
              pages: listPageViewModel(),
              onDone: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Home()));
              },
              showSkipButton: true,
              skip: const Text("Skip",
                  style: TextStyle(fontSize: 15, color: Colors.black38)),
              done: const Text("Get started",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.blueAccent)),
              dotsDecorator: DotsDecorator(
                  size: const Size.square(10),
                  shape: CircleBorder(),
                  activeSize: Size.square(16),
                  activeColor: Colors.blueAccent,
                  color: Colors.black26,
                  spacing: const EdgeInsets.symmetric(horizontal: 6),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))))),
    );
  }

  List<PageViewModel> listPageViewModel() {
    List<PageViewModel> list = [
      PageViewModel(
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          imageFlex: 2,
          bodyTextStyle: TextStyle(
            fontSize: 16,
          ),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        title: "Surf",
        // title: "Surf",
        body: lorem,
        image: Image.asset('assets/boarding-1.png', fit: BoxFit.fitWidth),
      ),
      PageViewModel(
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          imageFlex: 2,
          bodyTextStyle: TextStyle(
            fontSize: 16,
          ),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        title: "Safe",
        body: lorem,
        image: Image.asset('assets/boarding-2.png', fit: BoxFit.fitWidth),
      ),
      PageViewModel(
        decoration: const PageDecoration(
          imagePadding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          imageFlex: 2,
          bodyTextStyle: TextStyle(
            fontSize: 16,
          ),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        title: "Share",
        body: lorem,
        image: Image.asset('assets/boarding-3.png', fit: BoxFit.fitWidth),
      ),
    ];
    return list;
  }
}
