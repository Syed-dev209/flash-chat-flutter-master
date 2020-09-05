import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'registration_screen.dart';
import 'package:flash_chat/components/RoundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync:this,//vsync act as ticker and we have to give it a initial state which is our current state object(_WelcomeScreenState) and in order to call our state object we use "this" keyword
     // upperBound: 100.0, //initially value goes to 0.0-1.0 . But we can custmoize it by using upperbound for max number and lowerbound for min number
    );
    //animation = CurvedAnimation(parent: controller,curve: Curves.easeIn); //parent me apna bnaya hua controller dety hain. Curve animaton0-1 work krti hai is lye hum apny controller me upper bound nahi use kar sakty
    animation=ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);
    controller.forward();  //telling animation to increase
    controller.addListener(() { //addlistener tells us what current value is going on and we can use those values to animate things.
      setState(() {});
      //print(controller.value); jb curve animation na ho jb hi work krta hai ye
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                 text:['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Rounded_button(
              colour: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: ()
              {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            Rounded_button(
              colour: Colors.blueAccent,
              title: 'Register',
              onPressed: ()
              {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

