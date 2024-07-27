// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:theate/presentation/constants/color.dart';

// class SeatArrangementEdit extends StatefulWidget {
//   final String ownerId;
//   final String screenId;
//   final Map<String, dynamic> screenData;

//   const SeatArrangementEdit({Key? key, required this.ownerId, required this.screenId, required this.screenData}) : super(key: key);

//   @override
//   _SeatArrangementEditState createState() => _SeatArrangementEditState();
// }

// class _SeatArrangementEditState extends State<SeatArrangementEdit> {
//   late Set<int> selectedSeats;

//   @override
//   void initState() {
//     super.initState();
//     selectedSeats = Set<int>.from(widget.screenData['selectedSeats'] ?? []);
//   }

//   @override
//   Widget build(BuildContext context) {
//     int rows = widget.screenData['rows'];
//     int columns = widget.screenData['columns'];

//     return Scaffold(
//       backgroundColor: MyColor().darkblue,
//       appBar: AppBar(
//         title: Text('Edit Seat Arrangement'),
//         backgroundColor: MyColor().primarycolor,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "Select seats to make available/unavailable",
//               style: TextStyle(color: MyColor().white, fontSize: 18),
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: columns,
//                 childAspectRatio: 1,
//                 crossAxisSpacing: 4,
//                 mainAxisSpacing: 4,
//               ),
//               itemCount: rows * columns,
//               itemBuilder: (context, index) {
//                 bool isSelected = selectedSeats.contains(index);
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       if (isSelected) {
//                         selectedSeats.remove(index);
//                       } else {
//                         selectedSeats.add(index);
//                       }
//                     });
//                   },
//                   child: SvgPicture.asset(
//                     isSelected
//                         ? 'asset/svg_selected_bus_seats.svg'
//                         : 'asset/svg_unselected_bus_seat.svg',
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildLegendItem('Seleted ', 'asset/svg_selected_bus_seats.svg'),
//                 _buildLegendItem('Unseleted', 'asset/svg_unselected_bus_seat.svg'),
                
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: _saveChanges,
//               child: Text('Save Changes'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: MyColor().primarycolor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendItem(String label, String assetPath) {
//     return Row(
//       children: [
//         SvgPicture.asset(
//           assetPath,
//           width: 24,
//           height: 24,
//         ),
//         SizedBox(width: 8),
//         Text(
//           label,
//           style: TextStyle(color: MyColor().white),
//         ),
//       ],
//     );
//   }

//   void _saveChanges() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('owners')
//           .doc(widget.ownerId)
//           .collection('screens')
//           .doc(widget.screenId)
//           .update({
//         'selectedSeats': selectedSeats.toList(),
//       });
//       Get.back(result: true);
//       Get.snackbar('Success', 'Seat arrangement updated successfully');
      
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update seat arrangement: $e');
//     }
//   }
// }