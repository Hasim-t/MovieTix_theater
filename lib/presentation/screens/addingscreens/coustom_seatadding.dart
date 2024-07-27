import 'package:book_my_seat/book_my_seat.dart';
import 'package:flutter/material.dart';
import 'package:theate/presentation/constants/color.dart';

class TheaterManagementScreen extends StatefulWidget {
  @override
  _TheaterManagementScreenState createState() => _TheaterManagementScreenState();
}

class _TheaterManagementScreenState extends State<TheaterManagementScreen> {
  int rows = 20;
  int cols = 20;
  int seatSize = 22;
  List<List<SeatState>> seatStates = [];
  List<int> horizontalGaps = [];
  List<int> verticalGaps = []; 
  Set<String> toggledSeats = {};
  TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _initializeSeats();
    _initializeGaps();
  }

  void _initializeSeats() {
    seatStates = List.generate(rows, (_) => List.filled(cols, SeatState.unselected));
  }

  void _initializeGaps() {
    horizontalGaps = List.filled(cols - 1, 2);
    verticalGaps = List.filled(rows - 1, 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: Text('Theater Management')
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Rows'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            rows = int.tryParse(value) ?? rows;
                            _initializeSeats();
                            _initializeGaps();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Columns'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            cols = int.tryParse(value) ?? cols;
                            _initializeSeats();
                            _initializeGaps();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _showGapCustomizationDialog,
                child: Text('Customize Walking Spaces'),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: CustomSeatLayoutWidget(
                        onSeatToggled: (rowI, colI) {
                          setState(() {
                            String seatId = 'R${rowI + 1}S${colI + 1}';
                            if (toggledSeats.contains(seatId)) {
                              toggledSeats.remove(seatId);
                            } else {
                              toggledSeats.add(seatId);
                            }
                          });
                        },
                        stateModel: CustomSeatLayoutStateModel(
                          rows: rows,
                          cols: cols,
                          seatSvgSize: seatSize,
                          pathSelectedSeat: 'asset/svg_selected_bus_seats.svg',
                          pathDisabledSeat: 'asset/svg_disabled_bus_seat.svg',
                          pathSoldSeat: 'asset/svg_sold_bus_seat.svg',
                          pathUnSelectedSeat: 'asset/svg_unselected_bus_seat.svg',
                          currentSeatsState: seatStates,
                          horizontalGaps: horizontalGaps,
                          verticalGaps: verticalGaps,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
               Image.asset('asset/theaterscreenpng.png', ),
             TextButton(
               style: ButtonStyle(
            
               ),
              onPressed: (){}, child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }

  void _showGapCustomizationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Customize Walking Spaces'),
        content: SingleChildScrollView(
          child: Column(
            children: [
               const Text('Horizontal Gaps (after each column):'),
              for (int i = 0; i < cols - 1; i++)
                Row(
                  children: [
                    Text('After column ${i + 1}:'),
                    Expanded(
                      child: Slider(
                        value: horizontalGaps[i].toDouble(),
                        min: 0,
                        max: 50,
                        divisions: 50,
                        label: horizontalGaps[i].toString(),
                        onChanged: (double value) {
                          setState(() {
                            horizontalGaps[i] = value.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              Divider(),
              Text('Vertical Gaps (after each row):'),
              for (int i = 0; i < rows - 1; i++) // Changed to rows - 2
                Row(
                  children: [
                    Text('After row ${i + 1}:'),
                    Expanded(
                      child: Slider(
                        value: verticalGaps[i].toDouble(),
                        min: 0,
                        max: 50,
                        divisions: 50,
                        label: verticalGaps[i].toString(),
                        onChanged: (double value) {
                          setState(() {
                            verticalGaps[i] = value.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}

class MovieSeatBookingScreen extends StatefulWidget {
  final int rows;
  final int cols;
  final int seatSize;
  final List<List<SeatState>> initialSeatStates;
  final List<int> horizontalGaps;
  final List<int> verticalGaps;
  final Set<String> toggledSeats;

  MovieSeatBookingScreen({
    required this.rows,
    required this.cols,
    required this.seatSize,
    required this.initialSeatStates,
    required this.horizontalGaps,
    required this.verticalGaps,
    required this.toggledSeats,
  });

  @override
  _MovieSeatBookingScreenState createState() => _MovieSeatBookingScreenState();
}

class _MovieSeatBookingScreenState extends State<MovieSeatBookingScreen> {
  late List<List<SeatState>> seatStates;
  late Set<String> toggledSeats;
  TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;

  @override
  void initState() {
    super.initState();
    seatStates = List.from(widget.initialSeatStates);
    toggledSeats = Set.from(widget.toggledSeats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Your Seats')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400, // Fixed height for the InteractiveViewer
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                onInteractionEnd: (ScaleEndDetails endDetails) {
                  setState(() {
                    _currentScale = _transformationController.value.getMaxScaleOnAxis();
                  });
                },
                child: CustomSeatLayoutWidget(
                  onSeatToggled: (rowI, colI) {
                    setState(() {
                      String seatId = 'R${rowI + 1}S${colI + 1}';
                      if (toggledSeats.contains(seatId)) {
                        toggledSeats.remove(seatId);
                      } else {
                        toggledSeats.add(seatId);
                      }
                    });
                  },
                  stateModel: CustomSeatLayoutStateModel(
                    rows: widget.rows,
                    cols: widget.cols,
                    seatSvgSize: widget.seatSize,
                    pathSelectedSeat: 'assets/svg_selected_bus_seats.svg',
                    pathDisabledSeat: 'assets/svg_disabled_bus_seat.svg',
                    pathSoldSeat: 'assets/svg_sold_bus_seat.svg',
                    pathUnSelectedSeat: 'assets/svg_unselected_bus_seat.svg',
                    currentSeatsState: seatStates,
                    horizontalGaps: widget.horizontalGaps,
                    verticalGaps: widget.verticalGaps,
                  ),
                ),
              ),
            ),
            Text('Current Zoom: ${(_currentScale * 100).toStringAsFixed(0)}%'),
            ElevatedButton(
              onPressed: () {
                _transformationController.value = Matrix4.identity();
                setState(() {
                  _currentScale = 1.0;
                });
              },
              child: Text('Reset Zoom'),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text('Toggled Seats: ${toggledSeats.join(", ")}'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Toggled seats: ${toggledSeats.join(", ")}');
              },
              child: Text('Confirm Toggled Seats'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSeatLayoutWidget extends StatefulWidget {
  final Function(int, int) onSeatToggled;
  final CustomSeatLayoutStateModel stateModel;

  CustomSeatLayoutWidget({
    required this.onSeatToggled,
    required this.stateModel,
  });

  @override
  _CustomSeatLayoutWidgetState createState() => _CustomSeatLayoutWidgetState();
}

class _CustomSeatLayoutWidgetState extends State<CustomSeatLayoutWidget> {
  late List<List<bool>> seatVisibility;

  @override
  void initState() {
    super.initState();
    _initializeSeatVisibility();
  }

    void _initializeSeatVisibility() {
    seatVisibility = List.generate(
      widget.stateModel.currentSeatsState.length,
      (i) => List.filled(widget.stateModel.currentSeatsState[i].length, true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.stateModel.currentSeatsState.length, (rowIndex) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.stateModel.currentSeatsState[rowIndex].length, (colIndex) {
                return Row(
                  children: [
                    _buildSeatSpace(rowIndex, colIndex),
                    if (colIndex < widget.stateModel.horizontalGaps.length)
                      SizedBox(width: widget.stateModel.horizontalGaps[colIndex].toDouble()),
                  ],
                );
              }),
            ),
            if (rowIndex < widget.stateModel.verticalGaps.length)
              SizedBox(height: widget.stateModel.verticalGaps[rowIndex].toDouble()),
          ],
        );
      }),
    );
  }

  Widget _buildSeatSpace(int rowIndex, int colIndex) {
    return Container(
      width: widget.stateModel.seatSvgSize.toDouble(),
      height: widget.stateModel.seatSvgSize.toDouble(),
      child: Stack(
        children: [
          _buildSeat(rowIndex, colIndex),
          Positioned(
            bottom: 2,
            right: 2,
            child: Text(
              '${String.fromCharCode(65 + rowIndex)}${colIndex + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(int rowIndex, int colIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          seatVisibility[rowIndex][colIndex] = !seatVisibility[rowIndex][colIndex];
        });
        widget.onSeatToggled(rowIndex, colIndex);
      },
      child: Opacity(
        opacity: seatVisibility[rowIndex][colIndex] ? 1.0 : 0.3,
        child: Container(
          decoration: BoxDecoration(
            color: _getSeatColor(widget.stateModel.currentSeatsState[rowIndex][colIndex]),
            borderRadius: BorderRadius.circular(5.0),
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


class CustomSeatLayoutStateModel{
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