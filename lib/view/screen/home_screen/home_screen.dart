import 'package:firebase_auth_app/view/screen/auth/crud/crud_screen.dart';
import 'package:firebase_auth_app/view/screen/auth/signin/signin.dart';
import 'package:flutter/material.dart';

import '../auth/user/user_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  centerTitle: true,
  title: Text("Home",style: TextStyle(color: Colors.redAccent,fontSize: 50),),
  leading: InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>UserScreen()));
      },
      child: const Icon(Icons.arrow_back)),
  actions: [
    Padding(
      padding: EdgeInsets.only(right: 18.0),
      child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>Sign_in_screen()));
          },

          child: Icon(Icons.logout)),
    )
  ],
),
body: Center(
  child: InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>CrudScreen()));
    },
      splashColor: Colors.red,
      child: Text("Crud")),
),
    );
  }
}
