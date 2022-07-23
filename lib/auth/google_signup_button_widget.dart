import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'google_sign_in.dart';
// ignore_for_file: prefer_const_constructors

class GoogleSignupButtonWidget extends StatelessWidget {
  const GoogleSignupButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(4),
    child: OutlinedButton.icon(
      label: Text(
        'Sign In With Google',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: Colors.black),
        textStyle: TextStyle(
          color: Colors.black,
        )
      ),

      icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
      onPressed: () {
        final provider =
        Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.login();
      },
    ),
  );
}