import 'package:flutter/material.dart';
import 'package:market_place/auth/auth.dart';

class SignIn extends StatefulWidget {
  SignIn({this.type});
  final String type;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/log.png',
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: height / 3),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            width: width,
            height: 64,
            child: FlatButton(
              color: Color.fromRGBO(84, 52, 214, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: Text(
                'Sign in with Goolge',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () =>
                  auth.signInWithGoogle(context: context, type: widget.type),
            ),
          ),
        ],
      ),
    );
  }
}
