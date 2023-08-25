import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/view/screen/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Sign_in_screen extends StatefulWidget {
  const Sign_in_screen({super.key});

  @override
  State<Sign_in_screen> createState() => _Sign_in_screenState();
}

class _Sign_in_screenState extends State<Sign_in_screen> {


  bool isClicked=false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;


  signin(String email,String pass)async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass
      );
      Fluttertoast.showToast(
          msg: "Account created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>SingleChildScrollView(
            child: Padding(
              padding:const  EdgeInsets.only(
                  left: 20, right: 20, bottom: 24, top: 24),
              child: Column(
                  children: [
                    const SizedBox(height: 108,),
                    Form(
                        key: _formKey,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                  color: Color(0xFF2E2C2C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const  SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Color(0xFF2E2C2C)),
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              decoration:const InputDecoration(
                                fillColor: Color(0xFFFFFFFF),
                                hintText: 'Enter  email',
                                hintStyle: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFCECECE)),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFC4CCF7),
                                        width: 1
                                    )),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFC4CCF7),
                                      width: 1
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(
                                        color: Color(0xFFC4CCF7),
                                        width: 1
                                    )
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'this field can not be empty';
                                } else if (!value.contains(RegExp('\@'))) {
                                  return 'Please enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const  SizedBox(
                              height: 16,
                            ),
                            const Text(
                              'Password',
                              style: TextStyle(
                                  color: Color(0xFF2E2C2C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const  SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: _passController,
                              style:const TextStyle(color: Color(0xFF2E2C2C)),
                              maxLines: 1,
                              obscureText: isClicked,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(onPressed: (){
                                  setState(() {
                                    isClicked=!isClicked;
                                  });
                                }, icon: isClicked ? Icon(Icons.visibility_off) : Icon(Icons.visibility)),
                                fillColor: Color(0xFFFFFFFF),
                                hintText: 'Enter password',
                                hintStyle: const TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFCECECE)),
                                filled: true,
                                border: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red)),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFC4CCF7),
                                      width: 1
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFC4CCF7),
                                      width: 1
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(
                                        color: Color(0xFFC4CCF7),
                                        width: 1
                                    )
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'this field can not be empty';
                                } else if (value.length < 6) {
                                  return 'Password should be more than 6 characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 56,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  onPressed: () =>signin(_emailController.text,_passController.text),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    backgroundColor: Color(0xFF0026FF),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(color: Color(0xffFFFFFF),fontSize: 18,fontWeight: FontWeight.w500),
                                  )),

                            )
                          ],
                        )
                    )
                  ]
              ),
            )
        ),
      ),
    );
  }
}