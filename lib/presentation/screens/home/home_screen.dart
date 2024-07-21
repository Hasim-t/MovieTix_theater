import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/screens/addingscreens/seatadd.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theate/presentation/screens/addingscreens/seatadding.dart';
import 'package:theate/presentation/screens/addingscreens/selectedseats.dart';
import 'package:theate/presentation/screens/editingscreen/date_time_edit.dart';
import 'package:theate/presentation/screens/editingscreen/editarrangement.dart';
import 'package:theate/presentation/screens/editingscreen/movie_edit.dart';
import 'package:theate/presentation/screens/editingscreen/seatediting.dart';

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
                Get.to(() => const SeataddingScreen());
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
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No screens found"));
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
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
                      'Rows: ${screenData['rows']}, Columns: ${screenData['columns']}, Total Seats: ${screenData['totalSeats']} Movie: ${screenData['movieName']}',
                      style: TextStyle(color: MyColor().white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditOptions(context, currentUser!.uid, doc.id, screenData);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Delete Screen',
                              middleText:
                                  'Are you sure you want to delete this screen?',
                              textConfirm: 'Delete',
                              textCancel: 'Cancel',
                              confirmTextColor: Colors.white,
                              onConfirm: () {
                                deleteScreen(currentUser!.uid, doc.id);
                                Get.back();
                              },
                            );
                          },
                        ),

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
            ),
          );
        },
      ),
    );
  }

   void _showEditOptions(BuildContext context, String ownerId, String screenId, Map<String, dynamic> screenData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Screen Details'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => Seatediting(ownerId: ownerId, screenId: screenId, screenData: screenData));
                },
              ),
              ListTile(
                leading: const Icon(Icons.movie),
                title: const Text('Edit Movie'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => MovieEdit(ownerId: ownerId, screenId: screenId, screenData: screenData));
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Edit Date/Time'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => DateTimeEdit(ownerId: ownerId, screenId: screenId, screenData: screenData));
                },
              ),
              ListTile(
                leading: const Icon(Icons.event_seat),
                title:  const Text('Edit Seat Arrangement'),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => SeatArrangementEdit(ownerId: ownerId, screenId: screenId, screenData: screenData));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
