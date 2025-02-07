import 'package:esab/db_service.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:esab/shared/widgets/inputs/outlined_input.dart';
import 'package:esab/shared/widgets/inputs/underlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../settings/presentation/widgets/snack_bar.dart';
import '../data/datasource/lens_db.dart';
import '../data/model/lens.dart';
import '../providers/lens_provider.dart';

class AdjustLensPercentageScreen extends ConsumerStatefulWidget {
  const AdjustLensPercentageScreen(
      {required this.title,
      required this.percentage,
      required this.imageUrl,
      required this.hours,
      required this.id,
      super.key});

  final String title;
  final int percentage;
  final String imageUrl;
  final String hours;
  final int id;

  @override
  ConsumerState<AdjustLensPercentageScreen> createState() =>
      _AdjustLensPercentageScreenState();
}

class _AdjustLensPercentageScreenState
    extends ConsumerState<AdjustLensPercentageScreen> {
  double currentHours = 20; // Current value of the slider
  DateTime? selectedDate = DateTime.now();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController calenderController =
      TextEditingController(text: DateTime.now().toString().substring(0, 10));
  final TextEditingController hoursController = TextEditingController();
  List<LensRecord> replacementLogs = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  getColor() {
    if (widget.percentage <= 30) {
      return AppColors.successColor;
    } else if (widget.percentage <= 70) {
      return AppColors.mediumColor;
    } else {
      return AppColors.errorColor;
    }
  }

  getStatement() {
    if (widget.percentage <= 30) {
      return 'In Good Condition';
    } else if (widget.percentage <= 70) {
      return 'In Average Condition';
    } else {
      return 'Replacement Recommended';
    }
  }

  @override
  void initState() {
    super.initState();
    hoursController.text = widget.hours;
    print("id:  ${widget.id}");
    print("hours:  ${widget.hours}");
    print("percentage:  ${widget.percentage}");
    _fetchReplacementLogs();
  }

  Future<void> _fetchReplacementLogs() async {
    final logs = await fetchRecordsById(widget.id);
    setState(() {
      replacementLogs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(replacementLogsProvider(widget.id));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Adjust Lens Percentage",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.cardBgColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Image.asset(
                                widget.imageUrl,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(widget.title, style: AppTextStyles.bodyText),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Percentage and Recommendation
                    Row(
                      children: [
                        Text(
                          '${widget.percentage}%',
                          style: const TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: getColor(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    color: AppColors.secondaryColor,
                                    size: 16,
                                  ),
                                  Positioned(
                                    top: 5,
                                    left: 3,
                                    child: Icon(
                                      Icons.percent,
                                      color: getColor(),
                                      size: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                getStatement(),
                                style: const TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Predicted Lifespan
                    Text(
                      'Predicted Lifespan: ${widget.hours} hours remaining',
                      style: const TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    "Recently adjust value",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                replacementLogs.isNotEmpty ?
                Expanded(
                  flex: 7,
                  child: SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                      replacementLogs.isNotEmpty ?
                      replacementLogs.map((log) {
                        return _buildAdjustValueChip(
                          "${log.hours} hrs",
                          DateFormat('dd MMM y - hh:mma')
                              .format(log.lastUpdated),
                        );
                      }).toList()
                          : [_buildAdjustValueChip("", "")],
                    ),
                  ),
                )
                    :
                const Expanded(
                  flex: 7,
                  child: Text(
                    "No Data Available..",style: AppTextStyles.secondaryMediumText,
                    textAlign: TextAlign.center,
                  ),
                )

              ],
            ),
            OutlinedInputField(
              showLable: false,
              inputType: TextInputType.number,
              suffix: InkWell(
                  onTap: () {
                    hoursController.text = '0';
                    setState(() {});
                  },
                  child: const Icon(Icons.refresh, color: Colors.white)),
              label: 'Hours',
              suffixText: " hrs",
              controller: hoursController,
            ),
            const Text(
              "Hours adjusted will automatically calculate lens wear percentage based on total lifespan (e.g., 100 hours = 100% wear).",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "0 hrs",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...List.generate(
                            21,
                            (index) {
                              int indexValue = 0;
                              if (hoursController.text.isNotEmpty) {
                                indexValue =
                                    int.parse(hoursController.text.trim()) ~/ 5;
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:
                                        2), // Add spacing between containers
                                child: Container(
                                  height: index == indexValue ? 50 : 25,
                                  width: 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: AppColors.labelColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Slider(
                        value: hoursController.text.isNotEmpty
                            ? double.parse(hoursController.text) / 100
                            : 0,
                        allowedInteraction: SliderInteraction.tapAndSlide,
                        activeColor: AppColors.transparent,
                        inactiveColor: AppColors.transparent,
                        onChanged: (value) {
                          print(value);
                          hoursController.text =
                              (value * 100).toInt().toString();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "100 hrs",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Date of Replacement*",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            UnderlinedInput(
              labelText: '',
              readOnly: true,
              controller: calenderController,
              suffix: InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 1),
                      currentDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1));
                  if (pickedDate != null) {
                    calenderController.text =
                        pickedDate.toString().substring(0, 10);
                    setState(() {});
                  }
                },
                child: const Icon(
                  Icons.calendar_month,
                  color: AppColors.labelColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Comments",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            UnderlinedInput(
              labelText: 'Comments',
              controller: commentsController,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomOutlinedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/replacementLog',
                          arguments: {
                            'id': widget.id,
                          });
                    },
                    text: 'View log',
                    imagePath: AppImages.memoryImg,
                    borderColor: AppColors.primaryColor,
                    textColor: AppColors.primaryColor,
                    imageColor: AppColors.primaryColor,
                    height: 64,
                    imageHeight: 18,
                    imageWidth: 18,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: CustomButton(
                    buttonText: 'Save values',
                    onTapCallback: () async {
                      // save();
                      final updatedRecord = LensRecord(
                        id: widget.id,
                        // Ensure you have an ID field in LensRecord
                        title: widget.title,
                        imageUrl: widget.imageUrl,
                        percentage: int.tryParse(hoursController.text) ??
                            widget.percentage,
                        hours: hoursController.text,
                        lastUpdated: DateTime.now(),
                        comments: commentsController.text,
                      );

                      await updateRecord(updatedRecord);
                      await addLog(updatedRecord);

                      await showCustomSnackBar(
                          context, 'Lens cover changes saved');

                      Navigator.pop(context, true);
                    },
                    backgroundColor: AppColors.secondaryColor,
                    height: 64,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustValueChip(String label, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.labelColor)),
      child: (label.isNotEmpty) ? Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ) : const Center(
        child: Text(
          "No Data Available",style: AppTextStyles.secondarySmallText,
        ),
      ),
    );
  }
}