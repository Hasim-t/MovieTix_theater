import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:theate/presentation/screens/home/booking_screen.dart';
import 'package:theate/presentation/screens/home/home_screen.dart';
import 'package:theate/presentation/screens/home/movies_screen.dart';

import '../presentation/screens/home/profile_screen.dart';

class BottomNavController extends GetxController {
  RxInt selectedIndex = 0.obs;

  final List<Widget> pages = [
    const HomeScreen(),
    const MoviesScreen(),
    const BookingScreen(),
    const ProfileScreen()
  ];

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
