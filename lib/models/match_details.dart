import 'participant_details.dart';  // Asegúrate de que la ruta sea correcta

class MatchDetails {
  final String matchId;
  final List<ParticipantDetails> participants;
  final String gameMode;
  final int gameDuration;

  MatchDetails({
    required this.matchId,
    required this.participants,
    required this.gameMode,
    required this.gameDuration,
  });

  factory MatchDetails.fromMap(Map<String, dynamic> map) {
    print(map);  // Agregamos esto para depurar los valores del map
    return MatchDetails(
      matchId: map['metadata']['matchId'] ?? '',
      participants: List<ParticipantDetails>.from(
          map['info']['participants'].map((participant) => ParticipantDetails.fromMap(participant))),
      gameMode: map['info']['gameMode'] ?? '',
      gameDuration: map['info']['gameDuration'] ?? 0,
    );
  }
}
