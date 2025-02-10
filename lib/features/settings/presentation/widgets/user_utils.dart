import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

// User Model
class User {
  final String userName;
  final String email;
  final File? profileImage;

  User({required this.userName, required this.email, this.profileImage});
}

// User Notifier (Manages User Data)
class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(userName: "User", email: "", profileImage: null)) {
    loadUserData();
  }

  // Load user data from SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? "User";
    final email = prefs.getString('email') ?? "";
    final profilePhoto = prefs.getString('profilePhoto') ?? "";

    File? imageFile;
    if (profilePhoto.isNotEmpty) {
      Uint8List imageBytes = base64Decode(profilePhoto);
      Directory tempDir = await getTemporaryDirectory();
      imageFile = File('${tempDir.path}/profile_photo.png');
      await imageFile.writeAsBytes(imageBytes);
    }

    state = User(userName: userName, email: email, profileImage: imageFile);
  }

  // Save user data to SharedPreferences and update state
  Future<void> saveUser(String userName, String email, File? imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      await prefs.setString('profilePhoto', base64Image);
    }

    await prefs.setString('userName', userName);
    await prefs.setString('email', email);

    state = User(userName: userName, email: email, profileImage: imageFile);
  }
}

// User Provider
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
