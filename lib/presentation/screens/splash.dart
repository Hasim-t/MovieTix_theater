import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theate/buisness_logic/authbloc/bloc/authbloc_bloc.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/screens/login_screen.dart';
import 'package:theate/presentation/screens/profile_screen.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthblocBloc, AuthblocState>(
     listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return  ProfileScreen();
          }));
        } else if (state is UnAutheticated) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));
        }
      },
      child: Scaffold(
        backgroundColor: MyColor().primarycolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 200,
                  width: 200,
                  child: Image.asset('asset/Movietix logo.png'))
            ],
          ),
        ),
      ),
    );
  }
}