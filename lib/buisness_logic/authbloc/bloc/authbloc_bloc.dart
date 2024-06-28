import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:theate/data/models/usermodel.dart';

part 'authbloc_event.dart';
part 'authbloc_state.dart';

class AuthblocBloc extends Bloc<AuthblocEvent, AuthblocState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthblocBloc() : super(AuthblocInitial()) {
    on<CheckLoginStatuesEvent>((event, emit) async {
      User? user;
      try {
        await Future.delayed(Duration(seconds: 3), () {
          user = _auth.currentUser;
        });
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAutheticated());
        }
      } catch (e) {
        emit(AutheticatedError(msg: e.toString()));
      }
    });

    on<SingupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserCredential = await _auth.createUserWithEmailAndPassword(
            email: event.user!.email.toString(),
            password: event.user.password.toString());

        final user = UserCredential.user;
        if (user != null) {
          FirebaseFirestore.instance.collection('owners').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'name': event.user.userid,
            'CreatedAt': DateTime.now()
          });
          emit(Authenticated(user));
        } else {
          emit(UnAutheticated());
        }
      } catch (e) {}
    });

    on<LoingEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserCredential = await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        final user = UserCredential.user;
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAutheticated());
        }
      } catch (e) {
        print(e.toString());
      }
    });

    on<LogoutEvent>(
      (event, emit) async {
        try {
          await _auth.signOut();
          emit(UnAutheticated());
        } catch (e) {
          emit(AutheticatedError(msg: e.toString()));
        }
      },
    );

    on<GoogleSignInEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _googleSignIn.signOut();

          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            emit(UnAutheticated());
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
              'createdAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
            emit(Authenticated(user));
          } else {
            emit(UnAutheticated());
          }
        } catch (e) {
          print('Google sign in Error $e');
        }
      },
    );
    on<EmailLogoutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        emit(UnAutheticated());
      } catch (e) {
        emit(AutheticatedError(msg: e.toString()));
      }
    });

    on<GoogleLogoutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        await _googleSignIn.signOut();
        emit(UnAutheticated());
      } catch (e) {
        emit(AutheticatedError(msg: e.toString()));
      }
    });
  }
}
