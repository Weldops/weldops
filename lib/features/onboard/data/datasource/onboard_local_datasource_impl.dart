import 'package:esab/features/onboard/data/datasource/onboard_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardLocalDataSourceImpl implements OnboardLocalDataSource {
  @override
  Future<bool> getOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstLaunch') ?? true;
  }

  @override
  Future<void> setOnboardingStatus(bool isFirstLaunch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', isFirstLaunch);
  }
}
