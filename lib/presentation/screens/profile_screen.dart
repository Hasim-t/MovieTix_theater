import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:theate/buisness_logic/auth/auth_getx.dart';

import 'package:theate/presentation/screens/login_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.user.value == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => LoginScreen());
        });
      }
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                final user = authController.user.value;
                if (user != null) {
                  for (UserInfo userInfo in user.providerData) {
                    if (userInfo.providerId == 'google.com') {
                      authController.googleLogout();
                      return;
                    }
                  }
                  authController.logout();
                }
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        // ... rest of your widget tree
      );
    });
  }
}