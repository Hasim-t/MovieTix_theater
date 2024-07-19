import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:theate/data/models/usermodel.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      user.value = _auth.currentUser;
    } catch (e) {
      print('Error checking login status $e');
    }
  }

  Future<void> signUp(Usermodel userModel) async {
    try {
      final UserCredential = await _auth.createUserWithEmailAndPassword(
          email: userModel.email!, password: userModel.password!);
      final user = UserCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('owners')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'email': user.email,
          'name': userModel.userid,
          'CreatedAt': DateTime.now()
        });
        this.user.value = user;
        print("User registered successfully: ${user.email}");
      }
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final UserCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user.value = UserCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'too-many-requests') {
        print('Too many login attempts. Try again later.');
      } else if (e.code == 'invalid-credential') {
        print('The provided credentials are invalid.');
      } else {
        print('Login error: ${e.message}');
      }
    } catch (e) {
      print("Unexpected login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _auth.signOut();
      user.value = null;
    } catch (e) {
      print("Error loggin out : $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSingIn() async {
    isLoading.value = true;
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('owners')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'createdAt': FieldValue.serverTimestamp()
        });
        this.user.value = user;
      }
    } catch (e) {
      print("Google sing in error ");
    }
  }

  Future<void> googleLogout() async {
    isLoading.value = true;
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      user.value = null;
    } catch (e) {
      print("Error logging out from Google : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
