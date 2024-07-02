import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/buisness_logic/auth/auth_getx.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/screens/login_screen.dart';
import 'package:theate/presentation/screens/profile_screen.dart';
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

      Future.delayed(Duration(seconds: 2), () {
      if (authController.user.value != null) {
        Get.offAll(() => ProfileScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
      
      return Scaffold(
        backgroundColor: MyColor().primarycolor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.asset('asset/Movietix logo.png'),
              )
            ],
          ),
        ),
      );
    }}
  
