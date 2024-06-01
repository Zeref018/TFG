import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tfg/api/php_api.dart';
import 'package:tfg/constants/general_configuration.dart';
import 'package:tfg/constants/map_keys/map_keys.dart';
import 'package:tfg/constants/response_codes.dart';
import 'package:tfg/models/queue_data.dart';
import 'package:tfg/models/match_details.dart';


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
  Future<String?> getProfileIconId(String uuid) async {
    http.Response response;
    String? profileIconId; // Cambio el nombre de ProfileIconId a profileIconId

    response = await PhpApiRepository().get(function: MapKeys.function.get_account_id, uri: '/$uuid?api_key=${GeneralConfiguration.get.api_key}');

    if (response.statusCode == ResponseCodes.get.success) {
      Map map = json.decode(response.body);
      // Convertir el valor a una cadena
      profileIconId = map[MapKeys.body.profile_Icon_Id].toString();
      return profileIconId;
    }

    return profileIconId;
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

    response = await PhpApiRepository().get(function: MapKeys.function.get_rank, uri: '/$id?api_key=${GeneralConfiguration.get.api_key}');


    if (response.statusCode == 200) {
      List queueData = json.decode(response.body) as List;
      QueueData? soloQData;
      QueueData? flexQData;

      for (var data in queueData) {
        if (data['queueType'] == 'RANKED_SOLO_5x5') {
          soloQData = QueueData.fromMap(data);
        } else if (data['queueType'] == 'RANKED_FLEX_SR') {
          flexQData = QueueData.fromMap(data);
        }
      }

      if (isSoloQ) {
        return soloQData;
      } else {
        return flexQData;
      }
    }

    return null;
  }

  Future<List<String>?> getGames(String uuid) async {
    http.Response response;
    List<String>? games;

    response = await PhpApiRepository().get(function: MapKeys.function.get_game, uri: '/$uuid/ids?start=0&count=20&api_key=${GeneralConfiguration.get.api_key}', isEuw: false);

    if (response.statusCode == ResponseCodes.get.success) {
      List<dynamic> list = json.decode(response.body);
      games = List<String>.from(list);
      return games;
    }

    return null;
  }

  Future<List<MatchDetails>?> getMatchDetails(List<String> matchIds) async {
    List<MatchDetails> matchDetailsList = [];

    for (String matchId in matchIds) {
      http.Response response = await PhpApiRepository().get(
        function: MapKeys.function.get_match,
        uri: '/$matchId?api_key=${GeneralConfiguration.get.api_key}',
        isEuw: false,
      );

      if (response.statusCode == ResponseCodes.get.success) {
        try {
          Map<String, dynamic> map = json.decode(response.body);
          matchDetailsList.add(MatchDetails.fromMap(map));
        } catch (e) {
          // Manejar el error de decodificación JSON
          print('Error decoding match details for matchId $matchId: $e');
        }
      } else {
        // Manejar el error de la respuesta
        print('Error fetching match details for matchId $matchId: ${response.statusCode}');
      }
    }

    return matchDetailsList.isNotEmpty ? matchDetailsList : null;
  }

}
//Sakurajima Mai #fito1
//YSKM #Zrf
//QUΑNDALE DlNGLE #EUW
//ejecutar en web: flutter run -d chrome --web-browser-flag "--disable-web-security"

//imagenes: https://ddragon.leagueoflegends.com/cdn/14.10.1/img/champion/Aatrox.png
//icono de la cuenta: https://ddragon.leagueoflegends.com/cdn/14.10.1/img/profileicon/6330.png
//git push origin master:main
// se puede añadir --force al final
