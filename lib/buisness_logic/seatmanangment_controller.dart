import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_my_seat/book_my_seat.dart';

class TheaterManagementController extends GetxController {
  var rows = 20.obs;
  var cols = 20.obs;
  var seatSize = 22.obs;
  var seatStates = <List<SeatState>>[].obs;
  var horizontalGaps = <int>[].obs;
  var verticalGaps = <int>[].obs;
  var toggledSeats = <String>{}.obs;
  final screenNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initializeSeats();
    initializeGaps();
  }

  void initializeSeats() {
    seatStates.value = List.generate(rows.value, (_) => List.filled(cols.value, SeatState.unselected));
  }

  void initializeGaps() {
    horizontalGaps.value = List.filled(cols.value - 1, 2);
    verticalGaps.value = List.filled(rows.value - 1, 2);
  }

  void updateRows(String value) {
    rows.value = int.tryParse(value) ?? rows.value;
    initializeSeats();
    initializeGaps();
  }

  void updateCols(String value) {
    cols.value = int.tryParse(value) ?? cols.value;
    initializeSeats();
    initializeGaps();
  }

  void toggleSeat(int rowI, int colI) {
    String seatId = 'R${rowI + 1}S${colI + 1}';
    if (toggledSeats.contains(seatId)) {
      toggledSeats.remove(seatId);
    } else {
      toggledSeats.add(seatId);
    }
  }

  void updateHorizontalGap(int index, double value) {
    horizontalGaps[index] = value.round();
    update();
  }

  void updateVerticalGap(int index, double value) {
    verticalGaps[index] = value.round();
    update();
  }

  Future<void> saveToFirebase() async {
    if (screenNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a screen name');
      return;
    }

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final screenDoc = FirebaseFirestore.instance
          .collection('owners')
          .doc(currentUser.uid)
          .collection('screens')
          .doc(screenNameController.text);

      List<String> flattenedSeatStates = [];
      for (var row in seatStates) {
        flattenedSeatStates.addAll(row.map((state) => state.toString().split('.').last));
      }

      await screenDoc.set({
        'rows': rows.value,
        'cols': cols.value,
        'seatSize': seatSize.value,
        'horizontalGaps': horizontalGaps,
        'verticalGaps': verticalGaps,
        'toggledSeats': toggledSeats.toList(),
        'seatStates': flattenedSeatStates,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar('Success', 'Screen layout saved successfully!');
    } catch (e) {
      print('Error saving seats to Firebase: $e');
      Get.snackbar('Error', 'Failed to save screen layout. Please try again.');
    }
  }
}