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
  var seatVisibility = <List<RxBool>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeSeats();
    initializeGaps();
    initializeSeatVisibility();
  }

  void initializeSeats() {
    seatStates.value = List.generate(
        rows.value, (_) => List.filled(cols.value, SeatState.unselected));
  }

  void initializeGaps() {
    horizontalGaps.value = List.filled(cols.value - 1, 2);
    verticalGaps.value = List.filled(rows.value - 1, 2);
  }

  void initializeSeatVisibility() {
    seatVisibility.value = List.generate(
        rows.value, (_) => List.generate(cols.value, (_) => true.obs));
  }

  void updateRows(String value) {
    rows.value = int.tryParse(value) ?? rows.value;
    initializeSeats();
    initializeGaps();
    initializeSeatVisibility();
  }

  void updateCols(String value) {
    cols.value = int.tryParse(value) ?? cols.value;
    initializeSeats();
    initializeGaps();
    initializeSeatVisibility();
  }

  void toggleSeatVisibility(int rowI, int colI) {
    seatVisibility[rowI][colI].toggle();
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

      // Flatten seat states
      List<String> flattenedSeatStates = seatStates
          .expand((row) => row.map((state) => state.toString().split('.').last))
          .toList();

      // Flatten seat visibility
      List<bool> flattenedSeatVisibility = seatVisibility
          .expand((row) => row.map((seat) => seat.value))
          .toList();

      await screenDoc.set({
        'rows': rows.value,
        'cols': cols.value,
        'seatSize': seatSize.value,
        'horizontalGaps': horizontalGaps.toList(),
        'verticalGaps': verticalGaps.toList(),
        'toggledSeats': toggledSeats.toList(),
        'seatStates': flattenedSeatStates,
        'seatVisibility': flattenedSeatVisibility,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      Get.back();
      Get.snackbar('Success', 'Screen layout saved successfully!');

      // Refresh the page by reloading the data
      await loadFromFirebase(screenNameController.text);
      screenNameController.clear();
      


      // Update the UI
      update();
    } catch (e) {
      print('Error saving seats to Firebase: $e');
      Get.snackbar('Error', 'Failed to save screen layout. Please try again.');
    }
  }

  // New method to load data from Firebase
  Future<void> loadFromFirebase(String screenName) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final screenDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(currentUser.uid)
          .collection('screens')
          .doc(screenName)
          .get();

      if (!screenDoc.exists) {
        throw Exception('Screen not found');
      }

      final data = screenDoc.data()!;

      rows.value = data['rows'];
      cols.value = data['cols'];
      seatSize.value = data['seatSize'];
      horizontalGaps.value = List<int>.from(data['horizontalGaps']);
      verticalGaps.value = List<int>.from(data['verticalGaps']);
      toggledSeats.value = Set<String>.from(data['toggledSeats']);

    
      List<String> flatStates = List<String>.from(data['seatStates']);
      seatStates.value = List.generate(
        rows.value,
        (i) => List.generate(
          cols.value,
          (j) => SeatState.values.firstWhere(
            (e) =>
                e.toString().split('.').last == flatStates[i * cols.value + j],
          ),
        ),
      );

     
      List<bool> flatVisibility = List<bool>.from(data['seatVisibility']);
      seatVisibility.value = List.generate(
        rows.value,
        (i) => List.generate(
          cols.value,
          (j) => flatVisibility[i * cols.value + j].obs,
        ),
      );

      screenNameController.text = screenName;
      update();
      Get.snackbar('Success', 'Screen layout loaded successfully!');
    } catch (e) {
      print('Error loading seats from Firebase: $e');
      Get.snackbar('Error', 'Failed to load screen layout. Please try again.');
    }
  }
}
