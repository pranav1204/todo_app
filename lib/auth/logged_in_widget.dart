import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'google_sign_in.dart';
// ignore_for_file: prefer_const_constructors

class LoggedInWidget extends StatelessWidget {
  const LoggedInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            maxRadius: 55,
            backgroundImage: NetworkImage(user?.photoURL ?? ''),
          ),
          SizedBox(height: 25),
          Text(
            'Name: ${user?.displayName}',
            style: TextStyle(color: Colors.black,fontSize: 25),
          ),
          SizedBox(height: 20),
          Text(
            'Email: ${user?.email}',
            style: TextStyle(color: Colors.black,fontSize: 20),
          ),SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                child: Text('Logout'),
              ),
              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('back'),
              ),
            ],
          )
        ],
      ),
    );
  }
}