import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/inputs/underlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../shared/widgets/dropdown/underline_dropdown.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  String role = 'Welder';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List roles = ['Welder', 'Cutter'];

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  static Future<void> saveUser(
      String userName, String email, File? imageFile,String role) async {
    final prefs = await SharedPreferences.getInstance();
    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      await prefs.setString('profilePhoto', base64Image);
    }

    await prefs.setString('userName', userName);
    await prefs.setString('email', email);
    await prefs.setString('role', role);

    print("Saved Image: ${prefs.getString('profilePhoto')}");
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    nameController.text = prefs.getString('userName') ?? 'User';
    emailController.text = prefs.getString('email') ?? 'abc@example.com';
    role = prefs.getString('role') ?? 'Welder';

    final profilePhoto = prefs.getString('profilePhoto') ?? "";
    if (profilePhoto != "" && profilePhoto.isNotEmpty) {
      Uint8List imageBytes = base64Decode(prefs.getString('profilePhoto')!);
      Directory tempDir = await getTemporaryDirectory();
      File imageFile = File('${tempDir.path}/profile_photo.png');

      await imageFile.writeAsBytes(imageBytes);
      _image = imageFile;
    }

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        foregroundColor: AppColors.secondaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text('Edit Profile', style: AppTextStyles.headerText),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey.shade400,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.yellow,
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            UnderlinedInput(
              labelText: 'Full Name',
              controller: nameController,
            ),
            UnderlineDropdown(
              label: 'Role',
              value: role,
              onChanged: (value) {
                role = value;
                setState(() {});
              },
              items: [
                ...roles.map(
                  (e) {
                    return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: AppTextStyles.bodyText,
                        ));
                  },
                )
              ],
            ),
            UnderlinedInput(
              labelText: 'Email',
              controller: emailController,
              readOnly: true,

            )
          ],
        ),
      )),
      bottomNavigationBar: CustomButton(
        buttonText: 'Save Changes',
        onTapCallback: () {
          saveUser(nameController.text.trim(), emailController.text.trim(), _image,role);
          Navigator.pop(context,true);
        },
      ),
    );
  }
}

Future<File?> getProfileImage(String image) async {
  final Uint8List imageBytes = base64Decode(image);
  final File imageFile = File('${(await getTemporaryDirectory()).path}/profile_photo.png');

  await imageFile.writeAsBytes(imageBytes);
  return imageFile;
}
