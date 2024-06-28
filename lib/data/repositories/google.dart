// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   // Google Sing in

//   singInWithGoogle() async {
//     // begin interactive sing in procces
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;

//     final credential = GoogleAuthProvider.credential(
//         accessToken: gAuth.accessToken, idToken: gAuth.idToken);
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
// }
