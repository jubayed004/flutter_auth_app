import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/view/screen/auth/signin/signin.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../model/model.dart';
import '../../home_screen/home_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  signup(String email, String pass)async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      ).then((value) {
        postUserDetails();
      });
      Fluttertoast.showToast(
          msg: "Account Login successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  bool isClicked=false;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
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
                              'Name',
                              style: TextStyle(
                                  color: Color(0xFF2E2C2C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const  SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Color(0xFF2E2C2C)),
                              maxLines: 1,
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration:const InputDecoration(
                                fillColor: Color(0xFFFFFFFF),
                                hintText: 'Enter your name',
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

                            ),
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
                            const  SizedBox(
                              height: 16,
                            ),
                            const Text(
                              'Post code',
                              style: TextStyle(
                                  color: Color(0xFF2E2C2C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const  SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Color(0xFF2E2C2C)),
                              maxLines: 1,
                              controller: _postCodeController,
                              keyboardType: TextInputType.text,
                              decoration:const InputDecoration(
                                fillColor: Color(0xFFFFFFFF),
                                hintText: 'post code',
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

                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 56,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  onPressed: () => signup(_emailController.text, _passController.text),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    backgroundColor: Color(0xFF0026FF),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(color: Color(0xffFFFFFF),fontSize: 18,fontWeight: FontWeight.w500),
                                  )),

                            )
                          ],
                        )
                    )]
              ),
            )
        ),
      ),
    ));
  }

  postUserDetails() async{

    User? user = auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = _nameController.text.toString();
    userModel.postcode = _postCodeController.text.toString();

    await fireStore.collection("users").doc(user.uid).set(userModel.toMap());

    Navigator.push(context, MaterialPageRoute(builder: (_) =>  Sign_in_screen()));
  }
}