import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fprojectfood/screens/policy_dialog.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/firstscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Easy Meal",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Palanquin",
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Our app will help you pick up a recipe from the products at hand. \n \n \n \n \n \n  ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Palanquin",
                                      letterSpacing: 2.0,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                            },
                            child: Text("Let's try it!",
                                style: TextStyle(fontSize: 18)),
                            color: Color(0xff24997f),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  "    By clicking the button, you agree with\n",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Palanquin",
                                  letterSpacing: 1.0,
                                  color: Colors.black38),
                              children: [
                                TextSpan(
                                  text: "  The offer  ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showModal(
                                        context: context,
                                        configuration:
                                            FadeScaleTransitionConfiguration(),
                                        builder: (context) {
                                          return PolicyDialog(
                                            mdFileName: 'offer.md',
                                          );
                                        },
                                      );
                                    },
                                ),
                                TextSpan(text: "and ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Palanquin",
                                      letterSpacing: 1.0,
                                      color: Colors.black38),),
                                TextSpan(
                                  text: "Terms & Conditions ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showModal(
                                        context: context,
                                        configuration: FadeScaleTransitionConfiguration(),
                                        builder: (context) {
                                          return PolicyDialog(
                                            mdFileName: 'terms_and_conditions.md',
                                          );
                                        },
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
            )
        )
    );
  }
}
