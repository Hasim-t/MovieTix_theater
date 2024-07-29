import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:theate/presentation/constants/color.dart';
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
              Get.to(() => TheaterManagementScreen());
            },
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 5),
        ],
        backgroundColor: MyColor().primarycolor,
        title: Row(
          children: [
            Image.asset(
              'asset/Movietix logo.png',
              height: 60,
              width: 60,
            ),
            const Text('Screens'),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('owners')
            .doc(currentUser?.uid)
            .collection('screens')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No screens found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var screen = snapshot.data!.docs[index];
              return Card(
                color: MyColor().primarycolor,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    screen.id,
                    style: TextStyle(color: MyColor().white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Rows: ${screen['rows']} Columns: ${screen['cols']}',
                    style: TextStyle(color: MyColor().white.withOpacity(0.7)),
                  ),
                  trailing: IconButton(
                    onPressed: () => _showDeleteConfirmation(context, currentUser?.uid, screen.id),
                    icon: Icon(Icons.delete, color: MyColor().red),
                  ),
                  onTap: () {
                    Get.snackbar('Screen Tapped', 'You tapped on ${screen.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String? userId, String screenId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Screen'),
          content: Text('Are you sure you want to delete this screen?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteScreen(userId, screenId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteScreen(String? userId, String screenId) async {
    if (userId == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(userId)
          .collection('screens')
          .doc(screenId)
          .delete();

      Get.snackbar('Success', 'Screen deleted successfully');
    } catch (e) {
      print('Error deleting screen: $e');
      Get.snackbar('Error', 'Failed to delete screen. Please try again.');
    }
  }
}