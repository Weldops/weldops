import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
 
 class TutorialCard extends StatelessWidget {
  final String thumbnailImage;
  final String title;
  final VoidCallback onTap;

  const TutorialCard({
    Key? key, // Add the key parameter here
    required this.thumbnailImage,
    required this.title,
    required this.onTap,
  }) : super(key: key); // Pass the key to the parent constructor

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: AppColors.cardBgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150, // Specify a fixed height
              width: double.infinity, // Fill available width
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset(
                  thumbnailImage,
                  fit: BoxFit.cover, // Ensures consistent image size
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: AppTextStyles.secondaryMediumText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
