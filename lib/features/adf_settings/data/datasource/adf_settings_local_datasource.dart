abstract class AdfSettingsLocalDataSource {
  Future<bool> saveAdfSettings(
      String deviceId, Map<String, dynamic> adfSettings);
  Future<bool> deleteAdfSettingsById(String id);
  Future<bool> updateAdfSettingsById(
      String id, Map<String, dynamic> updatedValues, bool isApply);
  Future<List<Map<String, dynamic>>?> getAdfSettingsByDeviceId(String deviceId);
}
