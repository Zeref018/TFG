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
    await prefs.remove(MapKeys.preferences.user_username); // Elimina el username guardado
    await prefs.remove(MapKeys.preferences.user_hashtag); // Elimina el hashtag guardado
  }

  Future<void> setUuid(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(MapKeys.preferences.user_uuid, uuid);
  }

  Future<void> setAccountId(String accountId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(MapKeys.preferences.user_account_id, accountId);
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(MapKeys.preferences.user_username, username); // Guarda el username
  }

  Future<void> setHashtag(String hashtag) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(MapKeys.preferences.user_hashtag, hashtag); // Guarda el hashtag
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(MapKeys.preferences.user_username); // Obtiene el username guardado
  }

  Future<String?> getHashtag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(MapKeys.preferences.user_hashtag); // Obtiene el hashtag guardado
  }
}
