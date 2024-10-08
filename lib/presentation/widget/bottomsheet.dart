import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/widget/textformwidget.dart';

void showProfileBottomSheet(BuildContext context, Map<String, dynamic> userData) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  TextEditingController namecontroller = TextEditingController(text: userData['name'] ?? '');
  TextEditingController phonecontroller = TextEditingController(text: userData['phone'] ?? '');
  TextEditingController addresscontroller = TextEditingController(text: userData['address'] ?? '');
  TextEditingController placecontroller = TextEditingController(text: userData['place'] ?? '');

  void saveUserDetails() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(currentUser.uid)
          .update({
        'name': namecontroller.text,
        'phone': phonecontroller.text,
        'address': addresscontroller.text,
        'place': placecontroller.text,
      });
       
    } catch (e) {
      print("Error updating user details: $e");
      // Show error message to user
    }
  }

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0.1),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              width: screenWidth,
              decoration: BoxDecoration(
                color: MyColor().darkblue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: MyColor().primarycolor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Edit Profile",
                        style: TextStyle(color: MyColor().primarycolor)),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: namecontroller, hintText: "Name"),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: phonecontroller, hintText: "Phone"),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: addresscontroller, hintText: "Address"),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: placecontroller, hintText: "Place"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveUserDetails,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Save"),
                    ),
                    const SizedBox(height: 20), 
                  ],
                ),
              ),
            ),
          ),
        );
      });
}