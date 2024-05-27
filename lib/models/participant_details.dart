class ParticipantDetails {
  final String championName;
  final int kills;
  final int deaths;
  final int assists;
  final int goldEarned;
  final int totalDamageDealt;
  final int visionScore;
  final bool win;
  final String teamPosition;
  final String riotIdGameName; // Añadir el campo riotIdGameName
  final String riotIdTagline;  // Añadir el campo riotIdTagline

  ParticipantDetails({
    required this.championName,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.goldEarned,
    required this.totalDamageDealt,
    required this.visionScore,
    required this.win,
    required this.teamPosition,
    required this.riotIdGameName, // Inicializar el campo riotIdGameName
    required this.riotIdTagline,  // Inicializar el campo riotIdTagline
  });

  factory ParticipantDetails.fromMap(Map<String, dynamic> map) {
    return ParticipantDetails(
      championName: map['championName'],
      kills: map['kills'],
      deaths: map['deaths'],
      assists: map['assists'],
      goldEarned: map['goldEarned'],
      totalDamageDealt: map['totalDamageDealt'],
      visionScore: map['visionScore'],
      win: map['win'],
      teamPosition: map['teamPosition'],
      riotIdGameName: map['riotIdGameName'], // Mapear el campo riotIdGameName
      riotIdTagline: map['riotIdTagline'],   // Mapear el campo riotIdTagline
    );
  }
}
