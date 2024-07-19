import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/presentation/constants/color.dart';

import 'package:theate/presentation/screens/movie_slection.dart';
import 'package:theate/presentation/widget/textformwidget.dart';

class SeataddingScreen extends StatelessWidget {
  const SeataddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController audinameController = TextEditingController();
    TextEditingController rowController = TextEditingController();
    TextEditingController columnController = TextEditingController();
    TextEditingController totalController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        foregroundColor: MyColor().primarycolor,
        backgroundColor: MyColor().darkblue,
        title: Text(
          "Add Screens",
          style: TextStyle(color: MyColor().white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          children: [
            CustomTextFormField(
              controller: audinameController, 
              hintText: "Audi name"
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: rowController, 
              hintText: "Total rows"
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: columnController, 
              hintText: "Total columns"
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: totalController, 
              hintText: "Total seats"
            ),
            SizedBox(height: 20),
            // In SeataddingScreen
 ElevatedButton(
              onPressed: () async {
                int rows = int.tryParse(rowController.text) ?? 0;
                int columns = int.tryParse(columnController.text) ?? 0;
                String audiName = audinameController.text;
                
                // Get the current user's ID
                String? ownerId = FirebaseAuth.instance.currentUser?.uid;
                
                if (ownerId != null) {
                  // Create a new document in the nested 'screens' collection
                  DocumentReference docRef = await FirebaseFirestore.instance
                    .collection('owners')
                    .doc(ownerId)
                    .collection('screens')
                    .add({
                      'audiName': audiName,
                      'rows': rows,
                      'columns': columns,
                      'totalSeats': rows * columns,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                  // Now we have the document ID
                  String screenId = docRef.id;

                  Get.to(() => MovieSelectionScreen(
                    rows: rows, 
                    columns: columns, 
                    audiName: audiName, 
                    screenId: screenId,
                    ownerId: ownerId,  // Pass the owner ID
                  ));
                } else {
                  // Handle the case where the user is not logged in
                  Get.snackbar('Error', 'User not logged in');
                }
              },
              child: const Text('Submit')
            )
          ],
        ),
      ),
    );
  }
}