import 'dart:convert';
import 'package:esab/features/settings/presentation/widgets/category_button.dart';
import 'package:esab/features/settings/presentation/widgets/tutorial_card.dart';
import 'package:esab/shared/widgets/inputs/outlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  final TextEditingController searchController = TextEditingController();
  List videos = [];
  List filteredVideos = [];
  List types = [];
  static const String all = 'All';

  String selectedType = all;

  fetchPartsData() async {
    final String response =
        await rootBundle.loadString('assets/data/tutorial.json');
    final data = json.decode(response);

    videos = data['tutorials'];
    filteredVideos = videos;
    for (Map x in videos) {
      if (!types.contains(x['category'])) {
        types.add(x['category']);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchPartsData();
    searchController.addListener(() {
      filterVideos();
    });
  }

  void filterVideos() {
    String query = searchController.text.toLowerCase();

    List selectedList = getSelectedVideos();

    List filtered = selectedList.where((video) {
      return video['title'].toLowerCase().contains(query);
    }).toList();

    setState(() {
      filteredVideos = filtered;
    });
  }

  List getSelectedVideos() {
    if (selectedType == 'All') {
      return videos;
    } else {
      return videos
          .where((video) => video['category'] == selectedType)
          .toList();
    }
  }

  void _updateSelectedType(String type) {
    setState(() {
      selectedType = type;
    });
    filterVideos();
  }

  @override
  void dispose() {
    searchController.removeListener(filterVideos);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        foregroundColor: AppColors.secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Watch Tutorials',
          style: AppTextStyles.headerText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            OutlinedInputField(
              showLable: false,
              label: 'Search Videos',
              controller: searchController,
              prefix: const Icon(
                Icons.search,
                color: AppColors.labelColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0), // Space before the first button
                    child: CategoryButton(
                      label: all,
                      selectedType: selectedType,
                      value: all,
                      onTap: () {
                        _updateSelectedType(all);
                      },
                    ),
                  ),
                  // Add padding around each category button
                  ...types.map((x) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0), // Horizontal space for each button
                      child: CategoryButton(
                        label: x,
                        selectedType: selectedType,
                        value: x,
                        onTap: () {
                          _updateSelectedType(x);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
           Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              children: filteredVideos.map((x) {
                return TutorialCard(
                  thumbnailImage: x['thumbnailImage'],
                  title: x['title'],
                  onTap: () {
                     
                  },
                );
              }).toList(),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
