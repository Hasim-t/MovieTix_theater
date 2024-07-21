import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:theate/presentation/screens/addingscreens/arrangement_seat.dart';

class DateTimeSet extends StatefulWidget {
  final String movieName;
  final String movieId;
  final int rows;
  final int columns;
  final String audiName;
  final String screenId;
  final String ownerId; 
   

  const DateTimeSet({
    Key? key, 
    required this.movieName,
    required this.movieId,
    required this.rows,
    required this.columns,
    required this.audiName,
    required this.screenId, required this.ownerId,  // Add this line
  }) : super(key: key);

  @override
  _DateTimeSetState createState() => _DateTimeSetState();
}

class _DateTimeSetState extends State<DateTimeSet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _selectedDateTimes = {};
void showAddTimeDialog() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          if (_selectedDateTimes.containsKey(_selectedDay)) {
            _selectedDateTimes[_selectedDay!]!.add(selectedTime.format(context));
          } else {
            _selectedDateTimes[_selectedDay!] = [selectedTime.format(context)];
          }
        });
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Set Dates & Times for ${widget.movieName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFDEB887),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _selectedDay != null ? showAddTimeDialog : null,
            child: Text('Add Time for Selected Date'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDateTimes.length,
              itemBuilder: (context, index) {
                final date = _selectedDateTimes.keys.elementAt(index);
                final times = _selectedDateTimes[date]!;
                return Card(
                  color: Colors.deepOrange.withOpacity(0.1),
                  child: ExpansionTile(
                    title: Text(
                      DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white),
                    ),
                    children: times.map((time) => ListTile(
                      title: Text(time, style: TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            times.remove(time);
                            if (times.isEmpty) {
                              _selectedDateTimes.remove(date);
                            }
                          });
                        },
                      ),
                    )).toList(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedDateTimes.isNotEmpty ? () {
                // Save the selected dates and times to Firestore
                _saveDatesToFirestore();
              } : null,
              child: Text('Save Dates and Times'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDatesToFirestore() async {
  // Convert DateTime keys to Timestamps for Firestore
  Map<String, List<String>> formattedDates = {};
  _selectedDateTimes.forEach((key, value) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(key);
    formattedDates[formattedDate] = value;
  });

  // Navigate to the seat arrangement page
  final result = await Get.to(() => ArrangementSeat(
    rows: widget.rows,
    columns: widget.columns,
    audiName: widget.audiName,
    movieId: widget.movieId,
    movieName: widget.movieName,
    schedules: formattedDates,
    screenId: widget.screenId,
  ));

  // If seat arrangement is completed and returned
  if (result != null && result is Set<int>) {
    try {
      // Update the existing document in the 'screens' collection
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(widget.ownerId)
          .collection('screens')
          .doc(widget.screenId)
          .update({
        'schedules': formattedDates,
        'selectedSeats': result.toList(),
        'movieId': widget.movieId,
        'movieName': widget.movieName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.closeAllSnackbars();
      Get.snackbar('Success', 'Movie schedules and seats saved successfully');
      
      // Add a slight delay before navigating back
      await Future.delayed(Duration(milliseconds: 500));
      
      // Navigate back only once, and only if we're still on this screen
      if (Get.currentRoute == '/DateTimeSet') {
        Get.back();
      }
    } catch (e) {
      Get.closeAllSnackbars();
      Get.snackbar('Error', 'Failed to save movie schedules and seats: $e');
    }
  }
}
}