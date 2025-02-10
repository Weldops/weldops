import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/state/replacement_log_provider.dart';

class ReplacementLogScreen extends ConsumerWidget {
  final int id;

  const ReplacementLogScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsState = ref.watch(replacementLogProvider(id));

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
      body: logsState.when(
        data: (logs) => logs.isEmpty
            ? const Center(
          child: Text(
            "No logs found, please enter a new log.",
            style: AppTextStyles.secondarySmallText,
          ),
        )
            : ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
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
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
        error: (error, stackTrace) => Center(
          child: Text("Error: ${error.toString()}"),
        ),
      ),
    );
  }}
