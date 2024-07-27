import 'package:flutter/material.dart';
import 'package:book_my_seat/book_my_seat.dart';
import 'package:theate/presentation/constants/color.dart';

class CustomSeatLayoutWidget extends StatelessWidget {
  final Function(int, int) onSeatToggled;
  final CustomSeatLayoutStateModel stateModel;

  CustomSeatLayoutWidget({
    required this.onSeatToggled,
    required this.stateModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(stateModel.rows, (rowIndex) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(stateModel.cols, (colIndex) {
                return Row(
                  children: [
                    _buildSeatSpace(rowIndex, colIndex),
                    if (colIndex < stateModel.horizontalGaps.length)
                      SizedBox(width: stateModel.horizontalGaps[colIndex].toDouble()),
                  ],
                );
              }),
            ),
            if (rowIndex < stateModel.verticalGaps.length)
              SizedBox(height: stateModel.verticalGaps[rowIndex].toDouble()),
          ],
        );
      }),
    );
  }

  Widget _buildSeatSpace(int rowIndex, int colIndex) {
    return GestureDetector(
      onTap: () => onSeatToggled(rowIndex, colIndex),
      child: Container(
        width: stateModel.seatSvgSize.toDouble(),
        height: stateModel.seatSvgSize.toDouble(),
        decoration: BoxDecoration(
          color: _getSeatColor(stateModel.currentSeatsState[rowIndex][colIndex]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            '${String.fromCharCode(65 + rowIndex)}${colIndex + 1}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
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

class CustomSeatLayoutStateModel {
  final int rows;
  final int cols;
  final int seatSvgSize;
  final String pathSelectedSeat;
  final String pathDisabledSeat;
  final String pathSoldSeat;
  final String pathUnSelectedSeat;
  final List<List<SeatState>> currentSeatsState;
  final List<int> horizontalGaps;
  final List<int> verticalGaps;

  CustomSeatLayoutStateModel({
    required this.rows,
    required this.cols,
    required this.seatSvgSize,
    required this.pathSelectedSeat,
    required this.pathDisabledSeat,
    required this.pathSoldSeat,
    required this.pathUnSelectedSeat,
    required this.currentSeatsState,
    required this.horizontalGaps,
    required this.verticalGaps,
  });
}