import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/screens/movie_slection.dart';
import 'package:theate/presentation/screens/seatadding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theate/presentation/screens/selectedseats.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> deleteScreen(String ownerId, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('screens')
          .doc(documentId)
          .delete();
      Get.snackbar('Success', 'Screen deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete screen: $e');
    }
  }

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
                Get.to(SeataddingScreen());
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
            Text('Screens ')
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: currentUser != null
          ? FirebaseFirestore.instance
              .collection('owners')
              .doc(currentUser.uid)
              .collection('screens')
              .orderBy('createdAt', descending: true)
              .snapshots()
          : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No screens found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var screenData = doc.data() as Map<String, dynamic>;
              return Card(
                color: MyColor().primarycolor,
                child: ListTile(
                  title: Text(screenData['audiName'],
                      style: TextStyle(color: MyColor().white)),
                  subtitle: Text(
                    'Rows: ${screenData['rows']}, Columns: ${screenData['columns']}, Total Seats: ${screenData['totalSeats']}',
                    style: TextStyle(color: MyColor().white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show confirmation dialog before deleting
                          Get.defaultDialog(
                            title: 'Delete Screen',
                            middleText:
                                'Are you sure you want to delete this screen?',
                            textConfirm: 'Delete',
                            textCancel: 'Cancel',
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              deleteScreen(currentUser!.uid,doc.id);
                              Get.back(); // Close the dialog
                            },
                          );
                        },
                      ),
                      Icon(Icons.theater_comedy, color: MyColor().white),
                    ],
                  ),
                  onTap: () {
                   Get.to(() => SelectedSeats(
                      screenData: screenData,
                      ownerId: currentUser!.uid,
                      screenId: doc.id,
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
