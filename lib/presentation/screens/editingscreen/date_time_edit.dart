// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:theate/presentation/constants/color.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:theate/presentation/screens/home/home_screen.dart';

// class DateTimeEdit extends StatefulWidget {
//   final String ownerId;
//   final String screenId;
//   final Map<String, dynamic> screenData;

//   const DateTimeEdit({Key? key, required this.ownerId, required this.screenId, required this.screenData}) : super(key: key);

//   @override
//   _DateTimeEditState createState() => _DateTimeEditState();
// }

// class _DateTimeEditState extends State<DateTimeEdit> {
//   late DateTime _focusedDay;
//   late DateTime? _selectedDay;
//   late Map<DateTime, List<String>> _selectedDateTimes;

//   @override
//   void initState() {
//     super.initState();
//     _focusedDay = DateTime.now();
//     _selectedDay = _focusedDay;
//     _selectedDateTimes = _convertSchedulesToDateTimes(widget.screenData['schedules'] ?? {});
//   }

//   Map<DateTime, List<String>> _convertSchedulesToDateTimes(Map<String, dynamic> schedules) {
//     Map<DateTime, List<String>> result = {};
//     schedules.forEach((key, value) {
//       DateTime date = DateFormat('yyyy-MM-dd').parse(key);
//       result[date] = List<String>.from(value);
//     });
//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColor().darkblue,
//       appBar: AppBar(
//         title: Text('Edit Date/Time'),
//         backgroundColor: MyColor().primarycolor,
//       ),
//       body: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.now(),
//             lastDay: DateTime.now().add(Duration(days: 365)),
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             calendarStyle: CalendarStyle(
//               selectedDecoration: BoxDecoration(
//                 color: MyColor().primarycolor,
//                 shape: BoxShape.circle,
//               ),
//               todayDecoration: BoxDecoration(
//                 color: MyColor().primarycolor.withOpacity(0.5),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => _showAddTimeDialog(context),
//             child: Text('Add Time for Selected Date'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: MyColor().primarycolor,
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _selectedDateTimes.length,
//               itemBuilder: (context, index) {
//                 final date = _selectedDateTimes.keys.elementAt(index);
//                 final times = _selectedDateTimes[date]!;
//                 return Card(
//                   color: MyColor().primarycolor,
//                   child: ExpansionTile(
//                     title: Text(
//                       DateFormat('yyyy-MM-dd').format(date),
//                       style: TextStyle(color: MyColor().white),
//                     ),
//                     children: times.map((time) => ListTile(
//                       title: Text(time, style: TextStyle(color: MyColor().white)),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => _removeTime(date, time),
//                       ),
//                     )).toList(),
//                   ),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _saveChanges,
//             child: Text('Save Changes'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: MyColor().primarycolor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAddTimeDialog(BuildContext context) {
//     showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     ).then((selectedTime) {
//       if (selectedTime != null && _selectedDay != null) {
//         setState(() {
//           if (_selectedDateTimes.containsKey(_selectedDay)) {
//             _selectedDateTimes[_selectedDay!]!.add(selectedTime.format(context));
//           } else {
//             _selectedDateTimes[_selectedDay!] = [selectedTime.format(context)];
//           }
//         });
//       }
//     });
//   }

//   void _removeTime(DateTime date, String time) {
//     setState(() {
//       _selectedDateTimes[date]!.remove(time);
//       if (_selectedDateTimes[date]!.isEmpty) {
//         _selectedDateTimes.remove(date);
//       }
//     });
//   }

//   void _saveChanges() async {
//     try {
//       Map<String, List<String>> formattedDates = {};
//       _selectedDateTimes.forEach((key, value) {
//         String formattedDate = DateFormat('yyyy-MM-dd').format(key);
//         formattedDates[formattedDate] = value;
//       });

//       await FirebaseFirestore.instance
//           .collection('owners')
//           .doc(widget.ownerId)
//           .collection('screens')
//           .doc(widget.screenId)
//           .update({
//         'schedules': formattedDates,
//       });

//       Get.snackbar('Success', 'Date and time updated successfully');
//       Get.offAll(() => HomeScreen());
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update date and time: $e');
//     }
//   }
// }