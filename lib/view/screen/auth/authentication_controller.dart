// import 'dart:convert';
// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crypto/crypto.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:qr_code_generator/core/route/app_route.dart';
// import 'package:qr_code_generator/model/user_model.dart';
// import 'package:qr_code_generator/utils/app_colors.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// import '../../model/model.dart';
//
// class AuthenticationController extends GetxController{
//
//   bool isObscure = true;
//   bool isLoading = false;
//   bool rememberMe = false;
//
//   final loginFormKey = GlobalKey<FormState>();
//   final registerFormKey = GlobalKey<FormState>();
//
//   final emailRegExP = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
//
//   int selectedIndex = 0;
//   List<String> tabTitle = ["Log In", "Sign Up"];
//
//   /// sign In
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   /// sign up
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController postCodeController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passController = TextEditingController();
//
//   final auth = FirebaseAuth.instance;
//   FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
//
//   /// for firebase sign up
//   void registerUser({required String email, required String password}) async {
//
//     isLoading = true;
//     update();
//
//     if(registerFormKey.currentState!.validate()) {
//       await auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password
//       ).then((value) => {
//         postDetailsToFireStore()
//       }).catchError((e){
//         Fluttertoast.showToast(
//             msg: e!.message,
//             backgroundColor: Colors.red
//         );
//
//         isLoading = false;
//         update();
//       });
//     }
//
//     isLoading = false;
//     update();
//   }
//
//   /// added user info in firebase fire store
//   postDetailsToFireStore() async{
//
//     User? user = auth.currentUser;
//
//     UserModel userModel = UserModel();
//
//     userModel.email = user!.email;
//     userModel.uid = user.uid;
//     userModel.userName = nameController.text.toString();
//     userModel.postCode = postCodeController.text.toString();
//
//     await firebaseFireStore.collection("users")
//         .doc(user.uid)
//         .set(userModel.toMap());
//
//     Fluttertoast.showToast(
//         msg: "Account created successfully",
//         backgroundColor: AppColors.successColor,
//         textColor: AppColors.colorBlack,
//         fontSize: 14,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM
//     );
//
//     gotoNextScreen();
//   }
//
//   void changeIndex(int index) {
//     selectedIndex = index;
//     update();
//   }
//
//   /// google sign in
//
//   late GoogleSignInAccount? googleUser;
//   var googleSignIn = GoogleSignIn();
//
//   Future<User?> signInWithGoogle() async {
//
//     try{
//       // Trigger the authentication flow
//       googleUser = await googleSignIn.signIn();
//
//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//
//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//
//       final User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
//
//       await firebaseFireStore.collection("users")
//           .doc(user!.uid)
//           .set({
//         "username" : user.displayName,
//         "email" : user.email,
//         "imageSrc" : user.photoURL,
//         "phoneNumber" : user.phoneNumber
//       });
//
//       // Once signed in, return the UserCredential
//       return user;
//     } catch(e){
//       print("Error Message: $e");
//     } finally{
//       Get.back();
//     }
//   }
//
//   void handleGoogleLogin() async{
//     showDialog(
//       context: Get.context!,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
//       },
//     );
//
//     User? user = await signInWithGoogle();
//     if(user != null){
//       Get.offAndToNamed(AppRoute.homeScreen);
//     }else{
//       Get.back();
//     }
//
//   }
//
//   /// apple sign in
//   /// Generates a cryptographically secure random nonce, to be included in a
//   /// credential request.
//   String generateNonce([int length = 32]) {
//     const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final random = Random.secure();
//     return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//         .join();
//   }
//
//   /// Returns the sha256 hash of [input] in hex notation.
//   String sha256ofString(String input) {
//     final bytes = utf8.encode(input);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }
//
//   Future<UserCredential> signInWithApple() async {
//     final rawNonce = generateNonce();
//     final nonce = sha256ofString(rawNonce);
//
//     // Request credential for the currently signed in Apple account.
//     final appleCredential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//       nonce: nonce,
//     );
//
//     // Create an `OAuthCredential` from the credential returned by Apple.
//     final oauthCredential = OAuthProvider("apple.com").credential(
//       idToken: appleCredential.identityToken,
//       rawNonce: rawNonce,
//     );
//
//     // Sign in the user with Firebase. If the nonce we generated earlier does
//     // not match the nonce in `appleCredential.identityToken`, sign in will fail.
//     return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
//   }
//
//   /// firebase sign in
//   void loginUser(String email, String password) async{
//
//     isLoading = true;
//     update();
//
//
//     if(loginFormKey.currentState!.validate()) {
//       await auth.signInWithEmailAndPassword(
//           email: email,
//           password: password
//       ).then((uid) => {
//         Fluttertoast.showToast(
//             msg: "Login Successfully",
//             backgroundColor: AppColors.successColor,
//             textColor: AppColors.colorBlack,
//             fontSize: 14,
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM
//         ),
//         gotoNextScreen()
//       }).catchError((e){
//         Fluttertoast.showToast(
//             msg: e!.message,
//             backgroundColor: AppColors.primaryColor,
//             textColor: AppColors.colorWhite,
//             fontSize: 14,
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM
//         );
//
//         isLoading = false;
//         update();
//       });
//     }
//
//     usernameController.text = "";
//     passwordController.text = "";
//
//     isLoading = false;
//     update();
//   }
//
//   /// after login next screen
//   void gotoNextScreen(){
//     Get.offAndToNamed(AppRoute.homeScreen);
//   }
// }
