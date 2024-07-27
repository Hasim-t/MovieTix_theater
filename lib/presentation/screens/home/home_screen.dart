import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/presentation/constants/color.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theate/presentation/screens/addingscreens/coustom_seatadding.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
        backgroundColor: MyColor().darkblue,
        appBar: AppBar(
          actions: [
            IconButton(
                iconSize: 35,
                onPressed: () {
                  // Get.to(() => const SeataddingScreen());

                  Get.to(() => TheaterManagementScreen());
                },
                icon: const Icon(Icons.add)),
            const SizedBox(
              width: 5,
            )
          ],
          backgroundColor: MyColor().primarycolor,
          title: Row(
            children: [
              Image.asset(
                'asset/Movietix logo.png',
                height: 60,
                width: 60,
              ),
              const Text('Screens ')
            ],
          ),
        ),
        body: Column(
          children: [],
        ));
  }
}
