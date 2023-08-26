import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../model/model.dart';


class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel nameuser = UserModel();

  Future<void> getUserName() async {

    FirebaseFirestore.instance.collection("users").doc(user!.uid).get()
        .then((value){
      nameuser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text(nameuser.name ??'',style: TextStyle(fontSize: 22),)),
            Center(child: Text(nameuser.email ??'',style: TextStyle(fontSize: 22),)),
            Center(child: Text(nameuser.postcode ??'',style: TextStyle(fontSize: 22),)),
            Center(child: Text(nameuser.uid ??'',style: TextStyle(fontSize: 22),)),
          ],
        ),
      ),
    );
  }
}