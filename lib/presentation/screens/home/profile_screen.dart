import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/buisness_logic/auth/auth_getx.dart';
import 'package:theate/data/repositories/image_picker.dart';
import 'package:theate/presentation/constants/color.dart';

import 'package:theate/presentation/screens/profile/login_screen.dart';
import 'package:theate/presentation/screens/profile/profile_deatials.dart';
import 'package:theate/presentation/widget/coustom_row_icon.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final AuthController authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.user.value == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => LoginScreen());
        });
      }
      return Scaffold(
        backgroundColor: MyColor().darkblue,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColor().darkblue,
          title: Text('Profile',
              style: TextStyle(
                  color: MyColor().primarycolor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('owners')
                  .doc(currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: MyColor().primarycolor));
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: TextStyle(color: MyColor().red)));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                      child: Text('No user data found',
                          style: TextStyle(color: MyColor().primarycolor)));
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String name = userData['name'] ?? 'User';
                String email = userData['email'] ?? 'No email';
                String? profileImageUrl = userData['profileImageUrl'];

                return Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyProfile()));
                            },
                            child: CircleAvatar(
                              radius: screenHeight * 0.1,
                              backgroundImage: profileImageUrl != null
                                  ? NetworkImage(profileImageUrl)
                                  : AssetImage('asset/avatarpng.png')
                                      as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColor().primarycolor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon:
                                    Icon(Icons.edit, color: MyColor().darkblue),
                                onPressed: () {
                                  showImageSourceDialog(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      name,
                      style: TextStyle(
                        color: MyColor().primarycolor,
                        fontFamily: 'Cabin',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      email,
                      style: TextStyle(
                        color: MyColor().primarycolor.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Divider(color: MyColor().primarycolor.withOpacity(0.2)),
                    SizedBox(height: screenHeight * 0.02),
                    CoustomRowIcontext(
                      icon: Icons.privacy_tip,
                      text: 'Privacy',
                      ontap: () {},
                    ),
                    CoustomRowIcontext(
                      icon: Icons.description,
                      text: 'Terms and conditions',
                      ontap: () {},
                    ),
                    CoustomRowIcontext(
                      icon: Icons.dark_mode,
                      text: 'Dark Mode',
                      ontap: () {},
                    ),
                    CoustomRowIcontext(
                      icon: Icons.share,
                      text: 'Share',
                      ontap: () {},
                    ),
                    CoustomRowIcontext(
                      icon: Icons.logout,
                      text: 'Logout',
                      color: MyColor().red,
                      ontap: () {
                        authController.showLogoutConfirmation();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
