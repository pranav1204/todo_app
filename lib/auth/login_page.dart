import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/login_controller.dart';
import 'package:todo_app/screens/home.dart';
// ignore_for_file: prefer_const_constructors


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(4),
        child: Center(
          child: Obx((){
            if(controller.googleAccount.value == null){
              return buildLoginButton();
            }else{
              return buildProfileView();
            }
          })
        ),
      ),
    );
  }
  Column buildProfileView(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: Image.network(controller.googleAccount.value?.photoUrl ?? '').image,
            radius: 100,
          ),
          Text(controller.googleAccount.value?.displayName ?? '',
            style: Get.textTheme.headline3,
          ),
          Text(controller.googleAccount.value?.email ?? '',
            style: Get.textTheme.bodyText1,),
          SizedBox(
            height: 10,
          ),
          ActionChip(
            avatar: Icon(Icons.logout),
              label: Text('Logout'),
              onPressed: (){
              controller.logout();
          }),
          ActionChip(
              label: Text('Go To Todo List'),
              onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
          })
        ],
    );
  }

  FloatingActionButton buildLoginButton(){
    return FloatingActionButton.extended(
      onPressed: (){
        controller.login();
      },
      label: Text('Sign in With Google'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      icon: Image.asset('assets/img.png',height: 20,width: 20,),
    );
  }
}

