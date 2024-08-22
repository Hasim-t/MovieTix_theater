import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theate/buisness_logic/seatmanangment_controller.dart';
import 'package:theate/presentation/constants/color.dart';

import 'package:theate/presentation/widget/coustomseat.dart';

class TheaterManagementScreen extends StatelessWidget {
  final TheaterManagementController controller = Get.put(TheaterManagementController());

   TheaterManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: const Text('Theater Management'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextField(
                style: TextStyle(
                  color: MyColor().white
                ),
                controller: controller.screenNameController,
                decoration: const InputDecoration(labelText: 'Screen Name'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: MyColor().white
                        ),
                        decoration: const InputDecoration(labelText: 'Rows'),
                        keyboardType: TextInputType.number,
                        onChanged: controller.updateRows,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: MyColor().white
                        ),
                        decoration: const InputDecoration(labelText: 'Columns'),
                        keyboardType: TextInputType.number,
                        onChanged: controller.updateCols,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _showGapCustomizationDialog,
                child: const Text('Customize Walking Spaces'),
              ),
             const  SizedBox(height: 16),
              Obx(() => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: InteractiveViewer(
                  constrained: false,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CustomSeatLayoutWidget(
                    onSeatToggled: controller.toggleSeatVisibility,
                    stateModel: CustomSeatLayoutStateModel(
                      rows: controller.rows.value,
                      cols: controller.cols.value,
                      seatSvgSize: controller.seatSize.value,
                      pathSelectedSeat: 'asset/svg_selected_bus_seats.svg',
                      pathDisabledSeat: 'asset/svg_disabled_bus_seat.svg',
                      pathSoldSeat: 'asset/svg_sold_bus_seat.svg',
                      pathUnSelectedSeat: 'asset/svg_unselected_bus_seat.svg',
                      currentSeatsState: controller.seatStates,
                      horizontalGaps: controller.horizontalGaps,
                      verticalGaps: controller.verticalGaps,
                      seatVisibility: controller.seatVisibility,
                    ),
                  ),
                ),
              )),
             const SizedBox(height: 16),
              Image.asset('asset/theaterscreenpng.png'),
              ElevatedButton(
                onPressed: controller.saveToFirebase,
                child: const Text('Save Screen Layout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGapCustomizationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Customize Walking Spaces'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Horizontal Gaps (after each column):'),
              Obx(() => Column(
                children: List.generate(controller.cols.value - 1, (i) => 
                  Row(
                    children: [
                      Text('After column ${i + 1}:'),
                      Expanded(
                        child: Slider(
                          value: controller.horizontalGaps[i].toDouble(),
                          min: 0,
                          max: 50,
                          divisions: 50,
                          label: controller.horizontalGaps[i].toString(),
                          onChanged: (double value) => controller.updateHorizontalGap(i, value),
                        ),
                      ),
                    ],
                  )
                ),
              )),
              const Divider(),
             const   Text('Vertical Gaps (after each row):'),
              Obx(() => Column(
                children: List.generate(controller.rows.value - 1, (i) => 
                  Row(
                    children: [
                      Text('After row ${i + 1}:'),
                      Expanded(
                        child: Slider(
                          value: controller.verticalGaps[i].toDouble(),
                          min: 0,
                          max: 50,
                          divisions: 50,
                          label: controller.verticalGaps[i].toString(),
                          onChanged: (double value) => controller.updateVerticalGap(i, value),
                        ),
                      ),
                    ],
                  )
                ),
              )),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}