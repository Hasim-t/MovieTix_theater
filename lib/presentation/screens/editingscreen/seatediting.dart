import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:theate/presentation/widget/textformwidget.dart';

class Seatediting extends StatefulWidget {
  final String ownerId;
  final String screenId;
  final Map<String, dynamic> screenData;

  const Seatediting({Key? key, required this.ownerId, required this.screenId, required this.screenData}) : super(key: key);

  @override
  _SeateditingState createState() => _SeateditingState();
}

class _SeateditingState extends State<Seatediting> {
  late TextEditingController audinameController;
  late TextEditingController rowController;
  late TextEditingController columnController;

  @override
  void initState() {
    super.initState();
    audinameController = TextEditingController(text: widget.screenData['audiName']);
    rowController = TextEditingController(text: widget.screenData['rows'].toString());
    columnController = TextEditingController(text: widget.screenData['columns'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        title: Text("Edit Screen Details"),
        backgroundColor: MyColor().primarycolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: audinameController,
              hintText: "Audi name",
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: rowController,
              hintText: "Total rows",
            ),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: columnController,
              hintText: "Total columns",
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateScreenDetails,
              child: const Text('Update Screen Details'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateScreenDetails() async {
    try {
      int rows = int.parse(rowController.text);
      int columns = int.parse(columnController.text);
      
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(widget.ownerId)
          .collection('screens')
          .doc(widget.screenId)
          .update({
        'audiName': audinameController.text,
        'rows': rows,
        'columns': columns,
        'totalSeats': rows * columns,
      });

      Get.snackbar('Success', 'Screen details updated successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update screen details: $e');
    }
  }

  @override
  void dispose() {
    audinameController.dispose();
    rowController.dispose();
    columnController.dispose();
    super.dispose();
  }
}