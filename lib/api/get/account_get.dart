import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tfg/api/php_api.dart';
import 'package:tfg/constants/general_configuration.dart';
import 'package:tfg/constants/map_keys/map_keys.dart';
import 'package:tfg/constants/response_codes.dart';
import 'package:tfg/models/queue_data.dart';

class AccountGetters {
  Future<String?> getId(String uuid) async {
    http.Response response;
    String? Id;

    response = await PhpApiRepository().get(function: MapKeys.function.get_account_id, uri: '/$uuid?api_key=${GeneralConfiguration.get.api_key}');

    if (response.statusCode == ResponseCodes.get.success) {
      Map map = json.decode(response.body);
      return map[MapKeys.body.account_id];
    }

    return Id;
  }

  Future<String?> getUuid(String username, String hashtag) async {
    http.Response response;
    String? uuid;

    response = await PhpApiRepository().get(function: MapKeys.function.get_uuid, uri: '/$username/$hashtag?api_key=${GeneralConfiguration.get.api_key}', isEuw: false);

    if (response.statusCode == ResponseCodes.get.success) {
      Map map = json.decode(response.body);
      return map[MapKeys.body.puuid];
    }

    return uuid;
  }

  Future<QueueData?> getRank(String id, {bool isSoloQ = true}) async {
    http.Response response;
    QueueData? queueData;

    response = await PhpApiRepository().get(function: MapKeys.function.get_rank, uri: '/$id?api_key=${GeneralConfiguration.get.api_key}');

    if (response.statusCode == ResponseCodes.get.success) {
      List queueData = json.decode(response.body) as List;
      if (queueData.isNotEmpty && isSoloQ) {
        return QueueData.fromMap(queueData[0]);
      } else if (queueData.length > 1 && !isSoloQ) {
        return QueueData.fromMap(queueData[1]);
      } else {
        return null;
      }

    }

    return queueData;
  }
}
//Sakurajima Mai #fito1
//YSKM #Zrf

//imagenes: https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Aatrox.png
