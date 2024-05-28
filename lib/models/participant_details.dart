class ParticipantDetails {
  final String riotIdGameName;
  final String riotIdTagline;
  final String championName;
  final int kills;
  final int deaths;
  final int assists;
  final int goldEarned;
  final int totalDamageDealt;
  final int visionScore;
  final bool win;
  final String teamPosition;
  final double damagePerMinute; // Añadir este campo
  final int teamId; // Añadir este campo

  ParticipantDetails({
    required this.riotIdGameName,
    required this.riotIdTagline,
    required this.championName,
    required this.kills,
    required this.deaths,
    required this.assists,
    required this.goldEarned,
    required this.totalDamageDealt,
    required this.visionScore,
    required this.win,
    required this.teamPosition,
    required this.damagePerMinute, // Inicializar este campo
    required this.teamId, // Inicializar este campo
  });

  factory ParticipantDetails.fromMap(Map<String, dynamic> map) {
    return ParticipantDetails(
      riotIdGameName: map['riotIdGameName'] ?? '',
      riotIdTagline: map['riotIdTagline'] ?? '',
      championName: map['championName'] ?? '',
      kills: map['kills'] ?? 0,
      deaths: map['deaths'] ?? 0,
      assists: map['assists'] ?? 0,
      goldEarned: map['goldEarned'] ?? 0,
      totalDamageDealt: map['totalDamageDealt'] ?? 0,
      visionScore: map['visionScore'] ?? 0,
      win: map['win'] ?? false,
      teamPosition: map['teamPosition'] ?? '',
      damagePerMinute: (map['damagePerMinute'] ?? map['challenges']?['damagePerMinute'] ?? 0.0).toDouble(), // Mapear este campo
      teamId: map['teamId'] ?? 0, // Mapear este campo
    );
  }

  static ParticipantDetails empty() {
    return ParticipantDetails(
      riotIdGameName: '',
      riotIdTagline: '',
      championName: '',
      kills: 0,
      deaths: 0,
      assists: 0,
      goldEarned: 0,
      totalDamageDealt: 0,
      visionScore: 0,
      win: false,
      teamPosition: '',
      damagePerMinute: 0.0,
      teamId: 0,
    );
  }
}
