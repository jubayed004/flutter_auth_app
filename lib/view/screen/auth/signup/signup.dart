import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/view/screen/auth/signin/signin.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../model/model.dart';
import '../../home_screen/home_screen.dart';
import '../googlelogin/googlelogin_Screen.dart';

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

  late GoogleSignInAccount? googleUser;
  var googleSignIn = GoogleSignIn();

  // bool isObscure = true;
  // bool isLoading = false;
  // bool rememberMe = false;
  bool isClicked=false;
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

  //google sign in



 //  Future<User?> signInWithGoogle() async {
 //
 //    try{
 //      // Trigger the authentication flow
 //      googleUser = await googleSignIn.signIn();
 //
 //      // Obtain the auth details from the request
 //      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
 //
 //      // Create a new credential
 //      final credential = GoogleAuthProvider.credential(
 //        accessToken: googleAuth?.accessToken,
 //        idToken: googleAuth?.idToken,
 //      );
 //
 //      final User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
 //
 //      UserModel userModel=UserModel();
 //
 //      userModel.email = user!.email;
 //      userModel.uid = user.uid;
 //      await fireStore.collection('users').doc(user!.uid).set({
 //        'name' : user.displayName,
 //        'email':user.email
 //
 //      });
 //
 //      // Once signed in, return the UserCredential
 //      return user;
 //    } catch(e){
 //      print("Error Message: $e");
 //    }
 //  }
 //  void handleGoogleLogin(context) async{
 //    showDialog(
 //      context: context,
 //      barrierDismissible: false,
 //      builder: (BuildContext context) {
 //        return const Center(child: CircularProgressIndicator(color: Colors.green));
 //      },
 //    );
 //
 //    User? user = await signInWithGoogle();
 //    if(user != null){
 //      Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
 //    }else{
 //      Navigator.pop(context);
 //    }
 //
 //  }
 // signOut()async{
 //    var result = await FirebaseAuth.instance.signOut();
 //    return result;
 // }
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          // Handle successful Google Sign-In
          print("Google Sign-In successful: ${userCredential.user!.displayName}");
          // Navigate to your desired screen or perform further actions
        }
      }
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(

      body:  LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>SingleChildScrollView(
            child: Padding(
              padding:const  EdgeInsets.only(
                  left: 20, right: 20, bottom: 24, top: 24),
              child: Column(

                  children: [
                    Text("Sigin Up Page",style: TextStyle(fontSize: 50,fontWeight: FontWeight.w900),),
                    const SizedBox(height: 24
                      ,),

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

                            ),
                            SizedBox(height: 16,),

                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return Sign_in_screen();
                                }));
                              },
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text("Login here",

                                    style: TextStyle(color: Colors.red),),
                              ),
                            ),
                            SizedBox( height: 24,),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                height: 46,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    border: Border.all(
                                        width: 1, color: Color(0xFFE6E7F4)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: ()async{
                                          await _signInWithGoogle();
                                          if(mounted){
                                            Navigator.push(context, MaterialPageRoute(builder:(_)=>HomeScreen()));
                                          }
                                        },
                                        child: Image.asset(
                                          'assets/logos/google.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      const  SizedBox(
                                        width: 16,
                                      ),
                                      const  Text('Google',
                                          style: TextStyle(
                                              color: Color(0xff2E2C2C),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              )),
                          const  SizedBox(
                            width: 16,
                          ),
                          Expanded(
                              child: Container(
                                height: 46,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color:const Color(0xFFFFFFFF),
                                    border: Border.all(
                                        width: 1, color: Color(0xFFE6E7F4)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: (){

                                        },
                                        child: Image.asset(
                                          'assets/logos/apple.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      const  SizedBox(
                                        width: 16,
                                      ),
                                      const  Text('Apple',
                                          style: TextStyle(
                                              color: Color(0xff2E2C2C),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
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