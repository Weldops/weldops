import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewDeviceCard extends StatelessWidget {
  final double height;
  final double width;
  final bool isGridView;

  const AddNewDeviceCard(
      {super.key,
      required this.height,
      required this.width,
      required this.isGridView});

  @override
  Widget build(BuildContext context) {
    navigateAddNewDevice() {
      Navigator.pushNamed(context, '/addDevice');
    }

    return GestureDetector(
      onTap: navigateAddNewDevice,
      child: SizedBox(
        height: height,
        width: width,
        child: Card(
          color: AppColors.cardBgColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: isGridView
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addNewDevice,
                          style: AppTextStyles.secondarySmallText,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addNewDevice,
                          style: AppTextStyles.secondarySmallText,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
