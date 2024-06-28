import 'package:flutter/material.dart';
import 'package:theate/presentation/constants/color.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      );
  }
}