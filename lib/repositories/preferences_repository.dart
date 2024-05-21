import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfg/api/get/account_get.dart';
import 'package:tfg/constants/map_keys/map_keys.dart';
import 'package:tfg/constants/memory.dart';

class PreferencesRepository {
  Future<void> initSession() async {
        String? accountId;
        final prefs = await SharedPreferences.getInstance();
        String? uuid = prefs.getString(MapKeys.preferences.user_uuid);

        if (uuid != null && uuid.isNotEmpty) {
          accountId = await AccountGetters().getId(uuid);
          if (accountId == null) {
            await cleanSessionPreferences();
          } else {
            prefs.setString(MapKeys.preferences.user_account_id, accountId);
            M.accountId = accountId;
          }
        }

        M.uuid = uuid ?? '';
  }

  Future<void> cleanSessionPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(MapKeys.preferences.user_account_id);
      await prefs.remove(MapKeys.preferences.user_uuid);
  }

  Future<void> setUuid(String uuid) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(MapKeys.preferences.user_uuid, uuid);
  }

  Future<void> setAccountId(String accountId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(MapKeys.preferences.user_account_id, accountId);
  }
}
