import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartDetailsScreen extends ConsumerStatefulWidget {
  const PartDetailsScreen({required this.part, super.key});
  final Map part;

  @override
  ConsumerState<PartDetailsScreen> createState() => _PartDetailsScreenState();
}

class _PartDetailsScreenState extends ConsumerState<PartDetailsScreen> {
  String selectedImage = '';
  String selectedHeading = '';
  bool isReadMore = false;
  List headings = ['Highlights', 'Specification', 'Ordering', 'Documents'];
  @override
  Widget build(BuildContext context) {
    if (selectedImage.isEmpty) {
      selectedImage = widget.part['partImages'][0];
    }
    if (selectedHeading.isEmpty) {
      selectedHeading = headings[0];
    }
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackgroundColor,
          foregroundColor: AppColors.secondaryColor,
          elevation: 0,
          centerTitle: true,
          actions: [
            Image.asset(
              'assets/images/forward.png',
              height: 44,
              width: 44,
              fit: BoxFit.contain,
            ),
          ],
          title:
              const Text('Product Details', style: AppTextStyles.appHeaderText),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  height: MediaQuery.of(context).size.height * 0.2,
                  selectedImage,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...widget.part['partImages'].map((x) {
                    bool isSelected = selectedImage == x;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedImage = x;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.transparent)),
                        width: 50,
                        height: 50,
                        child: Image.asset(x),
                      ),
                    );
                  })
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.part['title'],
                  style: AppTextStyles.appHeaderText,
                ),
              ),
              Text(
                isReadMore
                    ? widget.part['description']
                    : widget.part['subTitle'],
                style: AppTextStyles.secondaryRegularText,
              ),
              if (!isReadMore)
                InkWell(
                  onTap: () {
                    setState(() {
                      isReadMore = true;
                    });
                  },
                  child: const Text(
                    'Read more...',
                    style: TextStyle(
                        color: AppColors.labelColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: AppColors.cardBgColor,
                child: Row(
                  children: [
                    ...headings.map(
                      (x) {
                        bool isSelected = selectedHeading == x;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedHeading = x;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : AppColors.transparent))),
                            child: Text(
                              x,
                              style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.labelColor),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (selectedHeading == 'Highlights')
                Expanded(
                    child: ListView(
                  children: [
                    ...widget.part['Highlights'].map((x) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: CircleAvatar(
                                backgroundColor: AppColors.labelColor,
                                radius: 2,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                x,
                                style: AppTextStyles.secondaryMediumText,
                              ),
                            )
                          ],
                        ),
                      );
                    })
                  ],
                )),
              if (selectedHeading == 'Specification')
                Expanded(
                    child: ListView(
                  children: [
                    ...widget.part['specifications'].map((x) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '${x['label']} : ${x['value']}',
                          style: AppTextStyles.secondaryMediumText,
                        ),
                      );
                    })
                  ],
                )),
                 if (selectedHeading == 'Ordering')
                Expanded(
                    child: ListView(
                  children: [
                    ...widget.part['specifications'].map((x) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '${x['label']} : ${x['value']}',
                          style: AppTextStyles.secondaryMediumText,
                        ),
                      );
                    })
                  ],
                )),
                 if (selectedHeading == 'Documents')
                Expanded(
                    child: ListView(
                  children: [
                    ...widget.part['specifications'].map((x) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '${x['label']} : ${x['value']}',
                          style: AppTextStyles.secondaryMediumText,
                        ),
                      );
                    })
                  ],
                )),
             CustomButton(
                buttonText: "Request Information",
                onTapCallback: () {
                  
                }
              ),

            ],
          ),
        ));
  }
}
