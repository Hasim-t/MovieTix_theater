// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:theate/presentation/constants/color.dart';

// class SelectedSeats extends StatelessWidget {
//   final Map<String, dynamic> screenData;

//   const SelectedSeats({super.key, required this.screenData, required String ownerId, required String screenId});

//   @override
//   Widget build(BuildContext context) {
//     int rows = screenData['rows'];
//     int columns = screenData['columns'];
//     List<dynamic> selectedSeats = screenData['selectedSeats'] ?? [];

//     return Scaffold(
//       backgroundColor: MyColor().darkblue,
//       appBar: AppBar(
//         title: Text(screenData['audiName']),
//         backgroundColor: MyColor().primarycolor,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "Screen",
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
//                 return SvgPicture.asset(
//                   isSelected
//                       ? 'asset/svg_selected_bus_seats.svg'
//                       : 'asset/svg_unselected_bus_seat.svg',
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildLegendItem('asset/svg_selected_bus_seats.svg', 'Selected'),
//                 _buildLegendItem('asset/svg_unselected_bus_seat.svg', 'Available'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendItem(String assetName, String label) {
//     return Row(
//       children: [
//         SvgPicture.asset(assetName, width: 20, height: 20),
//         SizedBox(width: 8),
//         Text(label, style: TextStyle(color: MyColor().white)),
//       ],
//     );
//   }
// }