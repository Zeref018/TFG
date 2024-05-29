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
  final double damagePerMinute;
  final int totalDamageDealtToChampions;
  final int teamId;
  final int item0;
  final int item1;
  final int item2;
  final int item3;
  final int item4;
  final int item5;
  final int item6;
  final int totalMinionsKilled;
  final String summonerName;  // Nuevo campo
  final int championId;  // Nuevo campo

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
    required this.damagePerMinute,
    required this.totalDamageDealtToChampions,
    required this.teamId,
    required this.item0,
    required this.item1,
    required this.item2,
    required this.item3,
    required this.item4,
    required this.item5,
    required this.item6,
    required this.totalMinionsKilled,
    required this.summonerName,  // Inicializar este campo
    required this.championId,  // Inicializar este campo
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
      damagePerMinute: (map['damagePerMinute'] ?? map['challenges']?['damagePerMinute'] ?? 0.0).toDouble(),
      teamId: map['teamId'] ?? 0,
      totalDamageDealtToChampions: map['totalDamageDealtToChampions'] ?? 0,
      item0: map['item0'] ?? 0,
      item1: map['item1'] ?? 0,
      item2: map['item2'] ?? 0,
      item3: map['item3'] ?? 0,
      item4: map['item4'] ?? 0,
      item5: map['item5'] ?? 0,
      item6: map['item6'] ?? 0,
      totalMinionsKilled: map['totalMinionsKilled'] ?? 0,
      summonerName: map['summonerName'] ?? '',  // Mapear este campo
      championId: map['championId'] ?? 0,  // Mapear este campo
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
      totalDamageDealtToChampions: 0,
      item0: 0,
      item1: 0,
      item2: 0,
      item3: 0,
      item4: 0,
      item5: 0,
      item6: 0,
      totalMinionsKilled: 0,
      summonerName: '',  // Inicializar este campo
      championId: 0,  // Inicializar este campo
    );
  }
}
