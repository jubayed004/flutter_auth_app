import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        centerTitle: true,

        title: Text("Login"),
      ) ,
      body: Center(
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 24,horizontal: 20),
          child: Column(

            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Email"
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Password"
                ),
              ),
              ElevatedButton(onPressed: (){},
                  child: Text("Login")
              )
            ],
          ),
        ),
      ),
    );
  }

}
