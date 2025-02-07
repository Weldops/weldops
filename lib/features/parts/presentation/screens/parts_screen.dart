import 'dart:convert';

import 'package:esab/shared/widgets/inputs/outlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartsScreen extends ConsumerStatefulWidget {
  const PartsScreen({super.key});

  @override
  ConsumerState<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends ConsumerState<PartsScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedType = 'Consumables';
  List parts = [];
  final imageList = [
    {'imageUrl': 'assets/images/consumables.png', 'title': 'Consumables'},
    {'imageUrl': 'assets/images/torches.png', 'title': 'Torches'},
    {'imageUrl': 'assets/images/safety.png', 'title': 'PPE/Safety'},
    {'imageUrl': 'assets/images/welding_equ.png', 'title': 'Welding Equ'}
  ];

  fetchPartsData() async {
    final String response =
        await rootBundle.loadString('assets/data/parts.json');
    final data = json.decode(response);

    parts = data['parts'];
    setState(() {});
  }

  moveToPartDetails(part) async {
    Navigator.pushNamed(context, '/partDetails', arguments: {'part': part});
  }

  @override
  void initState() {
    fetchPartsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedList =
        parts.where((part) => part['partType'] == selectedType).toList();
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackgroundColor,
          foregroundColor: AppColors.secondaryColor,
          elevation: 0,
          actions: [
            Image.asset(
              AppImages.notificationIcon,
              height: 44,
              width: 44,
              fit: BoxFit.contain,
            ),
          ],
          title: Text(AppLocalizations.of(context)!.esabParts,
              style: AppTextStyles.headerText),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              OutlinedInputField(
                showLable: false,
                label: 'Search',
                controller: searchController,
                prefix: const Icon(
                  Icons.search,
                  color: AppColors.labelColor,
                ),
                suffix:
                    const Icon(Icons.filter_alt, color: AppColors.labelColor),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...imageList.map(
                    (e) {
                      bool isSelected = selectedType == e['title']!;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedType = e['title']!;
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.cardBgColor,
                              radius: MediaQuery.of(context).size.width * 0.1,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  e['imageUrl']!,
                                  color: isSelected
                                      ? AppColors.primaryBackgroundColor
                                      : AppColors.labelColor,
                                ),
                              ),
                            ),
                            Text(
                              e['title']!,
                              style: isSelected
                                  ? AppTextStyles.primaryMediumText
                                  : AppTextStyles.secondaryMediumText,
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    selectedType,
                    style: AppTextStyles.appHeaderText,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: [
                    ...selectedList.map(
                      (x) {
                        return InkWell(
                          onTap: () {
                            moveToPartDetails(x['partDetail']);
                          },
                          child: Card(
                            color: AppColors.cardBgColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Image.asset(x['partImage']),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    x['partName'],
                                    style: AppTextStyles.deviceTitle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
