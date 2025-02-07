import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.05),
      child: Align(
        alignment: Alignment.topLeft,
        child: Image.asset(
          AppImages.weldopsLogo2,
          height: 25,
          width: 170,
        ),
      ),
    );
  }
}
