import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/datasource/lens_db.dart';
import '../data/model/lens.dart';

class ReplacementLogScreen extends ConsumerStatefulWidget {
  final int id;

  const ReplacementLogScreen({required this.id, super.key});

  @override
  ConsumerState<ReplacementLogScreen> createState() =>
      _ReplacementLogScreenState();
}

class _ReplacementLogScreenState extends ConsumerState<ReplacementLogScreen> {
  List<LensRecord> replacementLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReplacementLogs();
  }

  Future<void> _fetchReplacementLogs() async {
    final logs = await fetchRecordsById(widget.id);
    setState(() {
      replacementLogs = logs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        foregroundColor: AppColors.secondaryColor,
        centerTitle: true,
        title: const Text(
          'Replacement Log',
          style: AppTextStyles.appHeaderText,
        ),
      ),
      body:isLoading
          ?  const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      )
          : Padding(
        padding: const EdgeInsets.all(15),
        child: replacementLogs.isEmpty
            ? Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.1,
              vertical: screenHeight * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/empty_log.png',
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                "No logs found please use the button and enter the new log",
                textAlign: TextAlign.center,
                style: AppTextStyles.secondarySmallText
                    .copyWith(fontWeight: FontWeight.w300),
              )
            ],
          ),
        )
            : ListView.builder(
          itemCount: replacementLogs.length,
          itemBuilder: (context, index) {
            final log = replacementLogs[index];
            return Card(
              color: AppColors.cardBgColor,
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 50,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLiteColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Text(
                                log.hours,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text("hrs",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log.title,
                                style: AppTextStyles.secondarySmallText
                                    .copyWith(
                                    fontWeight: FontWeight.w300)),
                            Text(
                              DateFormat('dd MMM y - hh:mma')
                                  .format(log.lastUpdated),
                              style: AppTextStyles.secondaryRegularText,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      log.comments ?? "No comments available.",
                      style: AppTextStyles.secondaryRegularText,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
