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
    return MatchDetails(
      matchId: map['metadata']['matchId'],
      participants: (map['info']['participants'] as List)
          .map((participant) => ParticipantDetails.fromMap(participant))
          .toList(),
      gameMode: map['info']['gameMode'],
      gameDuration: map['info']['gameDuration'],
    );
  }
}
