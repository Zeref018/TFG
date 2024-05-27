class ParticipantDetails {
  final String championName;
  final int kills;
  final int deaths;
  final int assists;
  final int goldEarned;
  final int totalDamageDealt;
  final int visionScore;
  final bool win;
  final String riotIdGameName;
  final String riotIdTagline;
  final String teamPosition;

  ParticipantDetails({
    required this.championName,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.goldEarned,
    required this.totalDamageDealt,
    required this.visionScore,
    required this.win,
    required this.riotIdGameName,
    required this.riotIdTagline,
    required this.teamPosition,
  });

  factory ParticipantDetails.fromMap(Map<String, dynamic> map) {
    print(map);  // Agregamos esto para depurar los valores del map
    return ParticipantDetails(
      championName: map['championName'] ?? '',
      kills: map['kills'] ?? 0,
      deaths: map['deaths'] ?? 0,
      assists: map['assists'] ?? 0,
      goldEarned: map['goldEarned'] ?? 0,
      totalDamageDealt: map['totalDamageDealt'] ?? 0,
      visionScore: map['visionScore'] ?? 0,
      win: map['win'] ?? false,
      riotIdGameName: map['riotIdGameName'] ?? '',
      riotIdTagline: map['riotIdTagline'] ?? '',
      teamPosition: map['teamPosition'] ?? '',
    );
  }
}
