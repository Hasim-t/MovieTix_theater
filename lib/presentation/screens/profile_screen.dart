import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theate/buisness_logic/authbloc/bloc/authbloc_bloc.dart';
import 'package:theate/presentation/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authbloc = BlocProvider.of<AuthblocBloc>(context);

    return BlocListener<AuthblocBloc, AuthblocState>(
      listener: (context, state) {
        if (state is UnAutheticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  for (UserInfo userInfo in user.providerData) {
                    if (userInfo.providerId == 'google.com') {
                      context.read<AuthblocBloc>().add(GoogleLogoutEvent());
                      return;
                    }
                  }
                  // If not Google, assume email
                  context.read<AuthblocBloc>().add(EmailLogoutEvent());
                }
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        // ... rest of your widget tree
      ),
    );
  }
}
