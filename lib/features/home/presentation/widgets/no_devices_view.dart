import 'package:esab/features/home/presentation/widgets/add_new_device_card.dart';
import 'package:flutter/material.dart';

class NoDevicesView extends StatelessWidget {
  const NoDevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
        child: AddNewDeviceCard(
      height: 152,
      width: screenWidth * 0.5,
      isGridView: true,
    ));
  }
}
