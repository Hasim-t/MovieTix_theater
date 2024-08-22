import 'package:book_my_seat/book_my_seat.dart';
import 'package:flutter/material.dart';
import 'package:theate/presentation/constants/color.dart';

class TheaterSeatLayout extends StatelessWidget {
  final Map<String, dynamic> screenData;
  final String screenId;

  const TheaterSeatLayout({super.key,required this.screenData, required this.screenId});

  @override
  Widget build(BuildContext context) {
    final int rows = screenData['rows'] ?? 0;
    final int cols = screenData['cols'] ?? 0;
    final List<dynamic> seatStates = screenData['seatStates'] as List<dynamic>? ?? [];
    final List<dynamic> seatVisibility = screenData['seatVisibility'] as List<dynamic>? ?? [];
    final List<int> horizontalGaps = List<int>.from(screenData['horizontalGaps'] ?? []);
    final List<int> verticalGaps = List<int>.from(screenData['verticalGaps'] ?? []);

    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: Text('Screen: $screenId'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(300),
              minScale: 0.5,
              maxScale: 4.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(rows, (rowIndex) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    String.fromCharCode(65 +  rowIndex ),
                                    style:  TextStyle(color: MyColor().white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...List.generate(cols, (colIndex) {
                                  final seatIndex = rowIndex * cols + colIndex;
                                  final isVisible = seatVisibility.isNotEmpty && seatIndex < seatVisibility.length
                                      ? seatVisibility[seatIndex]
                                      : true;
                                  final seatState = seatStates.isNotEmpty && seatIndex < seatStates.length
                                      ? SeatState.values.firstWhere(
                                          (e) => e.toString().split('.').last == seatStates[seatIndex],
                                          orElse: () => SeatState.unselected,
                                        )
                                      : SeatState.unselected;

                                  return Row(
                                    children: [
                                      SeatSpace(
                                        isVisible: isVisible,
                                        state: seatState,
                                        rowIndex: rowIndex,
                                        colIndex: colIndex,
                                      ),
                                      if (colIndex < cols - 1)
                                        SizedBox(width: horizontalGaps.isNotEmpty ? horizontalGaps[colIndex].toDouble() : 0),
                                    ],
                                  );
                                }),
                              ],
                            ),
                            if (rowIndex < rows - 1)
                              SizedBox(height: verticalGaps.isNotEmpty ? verticalGaps[rowIndex].toDouble() : 0),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset('asset/theaterscreenpng.png'),
          ),
        ],
      ),
    );
  }

  Widget buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
       const  SizedBox(width: 5),
        Text(label, style: TextStyle(color: MyColor().white)),
      ],
    );
  }
}

class SeatSpace extends StatelessWidget {
  final bool isVisible;
  final SeatState state;
  final int rowIndex;
  final int colIndex;

  const SeatSpace({
    super.key,
    required this.isVisible,
    required this.state,
    required this.rowIndex,
    required this.colIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30, // Fixed width for all seat spaces
      height: 30, // Fixed height for all seat spaces
      margin: const EdgeInsets.all(2),
      child: isVisible ? SeatWidget(state: state, rowIndex: rowIndex, colIndex: colIndex) : null,
    );
  }
}

class SeatWidget extends StatelessWidget {
  final SeatState state;
  final int rowIndex;
  final int colIndex;

  const SeatWidget({
    super.key,
    required this.state,
    required this.rowIndex,
    required this.colIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getSeatColor(state),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          '${String.fromCharCode(65 + rowIndex)}${colIndex + 1}',
          style: TextStyle(
            fontSize: 10,
            color: MyColor().white,
          ),
        ),
      ),
    );
  }

  Color _getSeatColor(SeatState state) {
    switch (state) {
      case SeatState.selected:
        return Colors.green;
      case SeatState.sold:
        return Colors.red;
      case SeatState.disabled:
        return Colors.grey;
      case SeatState.unselected:
      default:
        return MyColor().primarycolor;
    }
  }
}