class QueueData {
  final String leagueId;
  final String summonerId;
  final String queueType;
  final String rank;
  final String tier;
  final int leaguePoints;
  final int wins;
  final int losses;

  QueueData(this.leagueId, this.summonerId, this.queueType, this.rank, this.tier, this.leaguePoints, this.wins, this.losses);

  static QueueData fromMap(Map<String, dynamic> map) => QueueData(
    map['leagueId'],
    map['summonerId'],
    map['queueType'],
    map['rank'],
    map['tier'],
    int.parse(map['leaguePoints'].toString()),
    int.parse(map['wins'].toString()),
    int.parse(map['losses'].toString()),
  );
}
