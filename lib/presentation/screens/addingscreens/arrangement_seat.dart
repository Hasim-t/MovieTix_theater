import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theate/presentation/constants/color.dart';
import 'package:get/get.dart';
class ArrangementSeat extends StatelessWidget {
  final int rows;
  final int columns;
  final String audiName;
  final String movieId;
  final String movieName;
  final Map<String, List<String>> schedules;
  final String screenId;

  const ArrangementSeat({
    Key? key, 
    required this.rows, 
    required this.columns, 
    required this.audiName,
    required this.movieId,
    required this.movieName,
    required this.schedules,
    required this.screenId,
  }) : super(key: key);

 Future<Set<int>> saveToFirebase(Set<int> selectedSeats) async {
  try {
    await FirebaseFirestore.instance.collection('screens').doc(screenId).update({
      'audiName': audiName,
      'rows': rows,
      'columns': columns,
      'totalSeats': rows * columns,
      'selectedSeats': selectedSeats.toList(),
      'movieId': movieId,
      'movieName': movieName,
      'schedules': schedules,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    return selectedSeats;
  } catch (e) {
    print('Error saving to Firebase: $e');
    return selectedSeats;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        title: Text('Seat Arrangement'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text("Theatre Screen this side", style: TextStyle(color: MyColor().white)),
            const SizedBox(height: 16),
            Flexible(
              child: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: SeatLayoutWidget(
  rows: rows, 
  columns: columns,  
  onSave: (Set<int> selectedSeats) async {
    final result = await saveToFirebase(selectedSeats);
    return result;  // Return the result without navigating back here
  },
),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegendItem('asset/svg_selected_bus_seats.svg', 'Selected by you'),
                  _buildLegendItem('asset/svg_unselected_bus_seat.svg', 'Available'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String assetName, String label) {
    return Row(
      children: [
        SvgPicture.asset(assetName, width: 4, height: 15),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: MyColor().white)),
      ],
    );
  }
}

class SeatLayoutWidget extends StatefulWidget {
  final int rows;
  final int columns;
  final Function(Set<int>) onSave;

  SeatLayoutWidget({Key? key, required this.rows, required this.columns, required this.onSave}) : super(key: key);

  @override
  _SeatLayoutWidgetState createState() => _SeatLayoutWidgetState();
}

class _SeatLayoutWidgetState extends State<SeatLayoutWidget> with SingleTickerProviderStateMixin {
  Set<int> selectedSeats = {};
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.columns,
              childAspectRatio: 1,
            ),
            itemCount: widget.rows * widget.columns,
            itemBuilder: (context, index) {
              bool isSelected = selectedSeats.contains(index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedSeats.remove(index);
                    } else {
                      selectedSeats.add(index);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: isSelected
                      ? AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _animation.value,
                              child: SvgPicture.asset('asset/svg_selected_bus_seats.svg'),
                            );
                          },
                        )
                      : SvgPicture.asset('asset/svg_unselected_bus_seat.svg'),
                ),
              );
            },
          ),
        ),
      ElevatedButton(
  onPressed: () async {
    final result = await widget.onSave(selectedSeats);
    Get.back(result: result);  // Navigate back only once, after saving
  },
  child: Text("Save", style: TextStyle(color: MyColor().gray))
)
      ],
    );
  }
}