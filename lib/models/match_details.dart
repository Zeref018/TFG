class MatchDetails {
  final int? assists;
  final int? kills;
  final int? deaths;
  final int? championId;
  final String? championName;
  final int? goldEarned;
  final int? totalDamageDealt;
  final int? totalDamageDealtToChampions;
  final int? totalHeal;
  final int? visionScore;
  final bool? win;

  MatchDetails({
    this.assists,
    this.kills,
    this.deaths,
    this.championId,
    this.championName,
    this.goldEarned,
    this.totalDamageDealt,
    this.totalDamageDealtToChampions,
    this.totalHeal,
    this.visionScore,
    this.win,
  });

  factory MatchDetails.fromMap(Map<String, dynamic> map) {
    return MatchDetails(
      assists: map['assists'],
      kills: map['kills'],
      deaths: map['deaths'],
      championId: map['championId'],
      championName: map['championName'],
      goldEarned: map['goldEarned'],
      totalDamageDealt: map['totalDamageDealt'],
      totalDamageDealtToChampions: map['totalDamageDealtToChampions'],
      totalHeal: map['totalHeal'],
      visionScore: map['visionScore'],
      win: map['win'],
    );
  }
}
