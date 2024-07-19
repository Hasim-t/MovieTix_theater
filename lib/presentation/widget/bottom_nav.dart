import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/buisness_logic/bottom_nav_getx.dart';
import 'package:theate/presentation/constants/color.dart';


class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  MyColor().darkblue,
      body: Obx(() => bottomNavController.pages[bottomNavController.selectedIndex.value],),
      
      bottomNavigationBar: Obx(
       () => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        ),
         child: FlashyTabBar(
          
          
              selectedIndex: bottomNavController.selectedIndex.value,
              items: [
                FlashyTabBarItem(
                    icon: const  Icon(Icons.home), title:  Text('Home',style: TextStyle(color: MyColor().primarycolor  ),)),
                FlashyTabBarItem(
                    icon: const Icon(Icons.movie), title:  Text('Movies',style: TextStyle(color: MyColor().primarycolor  ),)),
                FlashyTabBarItem(
                    icon: const Icon(Icons.local_movies_rounded), title:  Text('Booking',style: TextStyle(color: MyColor().primarycolor  ),)),
                FlashyTabBarItem(
                    icon: const Icon(Icons.person), title:  Text('Profile',style: TextStyle(color: MyColor().primarycolor  ),)),
              ],
              onItemSelected: bottomNavController.setSelectedIndex),
       ),
      ),
    );
  }
}



 BottomNavController bottomNavController = Get.find<BottomNavController>();
