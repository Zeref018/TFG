import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg/base_cubit/base_cubit.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/models/excel_exporter.dart';
import 'package:tfg/widgets/loader.dart';
import 'package:tfg/repositories/preferences_repository.dart';
import 'cubit/match_history_cubit.dart';
import 'package:tfg/models/participant_details.dart';
import 'package:tfg/constants/custom_images.dart';
import 'package:tfg/constants/memory.dart';

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({Key? key}) : super(key: key);

  static const String url = '/match_history/';
  static const String route = '/match_history/';

  @override
  _MatchHistoryPageState createState() => _MatchHistoryPageState();
}

class _MatchHistoryPageState extends State<MatchHistoryPage> {
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseCubit, BaseState>(
      builder: (context, state) {
        return BlocProvider(
          create: (context) => MatchHistoryCubit(),
          child: BlocBuilder<MatchHistoryCubit, MatchHistoryState>(
            builder: (context, state) {
              if (state.pageStatus == PageStatusEnum.loading) {
                return const Loader();
              }

              if (state.matchDetails != null && _expanded.length != state.matchDetails!.length) {
                _expanded = List<bool>.filled(state.matchDetails!.length, false);
              }

              return Scaffold(
                backgroundColor: Colors.grey[850],
                appBar: AppBar(
                  title: Text(
                    'Match History',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                  backgroundColor: Colors.grey[850],
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.blueAccent),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Image.asset(
                        CustomImages.get.logo,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          FutureBuilder<String?>(
                            future: PreferencesRepository().getUsername(),
                            builder: (context, usernameSnapshot) {
                              if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (usernameSnapshot.hasError) {
                                return Text('Error loading username', style: TextStyle(color: Colors.white));
                              } else {
                                String username = usernameSnapshot.data ?? '';
                                return FutureBuilder<String?>(
                                  future: PreferencesRepository().getHashtag(),
                                  builder: (context, hashtagSnapshot) {
                                    if (hashtagSnapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (hashtagSnapshot.hasError) {
                                      return Text('Error loading hashtag', style: TextStyle(color: Colors.white));
                                    } else {
                                      String hashtag = hashtagSnapshot.data ?? '';
                                      return Column(
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '$username#$hashtag',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          if (state.matchDetails != null && state.matchDetails!.isNotEmpty)
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: state.matchDetails!.length,
                                              itemBuilder: (context, index) {
                                                final match = state.matchDetails![index];
                                                final currentUserParticipant = match.participants.firstWhere(
                                                      (p) => p.riotIdGameName == username && p.riotIdTagline == hashtag,
                                                  orElse: () => match.participants[0],
                                                );
                                                return Column(
                                                  children: [
                                                    Card(
                                                      color: currentUserParticipant.win
                                                          ? Colors.blue.withOpacity(0.4)
                                                          : Colors.red.withOpacity(0.4),
                                                      margin: EdgeInsets.symmetric(vertical: 8.0),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(16.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            LayoutBuilder(
                                                              builder: (context, constraints) {
                                                                final bool isMobile = constraints.maxWidth < 600;
                                                                return _buildParticipantCard(
                                                                  currentUserParticipant,
                                                                  username,
                                                                  hashtag,
                                                                  match.participants,
                                                                  match.gameDuration,
                                                                  isMobile,
                                                                );
                                                              },
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  _expanded[index] = !_expanded[index];
                                                                });
                                                              },
                                                              child: Text(
                                                                _expanded[index] ? 'Hide Details' : 'Show Details',
                                                                style: TextStyle(color: Colors.blueAccent),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (_expanded[index])
                                                      Column(
                                                        children: [
                                                          _buildExpandedDetailsHeader(),
                                                          ..._buildExpandedDetails(match.participants),
                                                        ],
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                          if (state.matchDetails == null || state.matchDetails!.isEmpty)
                                            Text('No match details available', style: TextStyle(color: Colors.white)),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (state.matchDetails != null) {
                                                exportToExcel(context, username, hashtag, state.matchDetails!);
                                              }
                                            },
                                            child: Text(
                                              'Download Excel',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blueAccent,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildExpandedDetailsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 32), // Espacio para la imagen del campeón
          SizedBox(width: 8),
          Expanded(child: Text('Summoner Name', style: TextStyle(color: Colors.white, fontSize: 14))),
          SizedBox(width: 8),
          Expanded(child: Text('K/D/A', style: TextStyle(color: Colors.white, fontSize: 14))),
          SizedBox(width: 8),
          Expanded(child: Text('KDA', style: TextStyle(color: Colors.white, fontSize: 14))),
          SizedBox(width: 8),
          Expanded(child: Text('Damage', style: TextStyle(color: Colors.white, fontSize: 14))),
          SizedBox(width: 8),
          Expanded(child: Text('Minions', style: TextStyle(color: Colors.white, fontSize: 14))),
          SizedBox(width: 8),
          Expanded(child: Text('Items', style: TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }

  List<Widget> _buildExpandedDetails(List<ParticipantDetails> participants) {
    return participants.map((participant) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/champion/${participant.championName}.png',
              width: 32,
              height: 32,
            ),
            SizedBox(width: 8),
            Expanded(child: Text(participant.summonerName, style: TextStyle(color: Colors.white, fontSize: 12))),
            SizedBox(width: 8),
            Expanded(child: Text('${participant.kills}/${participant.deaths}/${participant.assists}', style: TextStyle(color: Colors.white, fontSize: 12))),
            SizedBox(width: 8),
            Expanded(child: Text('${((participant.kills + participant.assists) / (participant.deaths > 0 ? participant.deaths : 1)).toStringAsFixed(2)}', style: TextStyle(color: Colors.white, fontSize: 12))),
            SizedBox(width: 8),
            Expanded(child: Text('${participant.totalDamageDealtToChampions}', style: TextStyle(color: Colors.white, fontSize: 12))),
            SizedBox(width: 8),
            Expanded(child: Text('${participant.totalMinionsKilled}', style: TextStyle(color: Colors.white, fontSize: 12))),
            SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildItemIcon(participant.item0),
                    _buildItemIcon(participant.item1),
                    _buildItemIcon(participant.item2),
                    _buildItemIcon(participant.item3),
                    _buildItemIcon(participant.item4),
                    _buildItemIcon(participant.item5),
                    _buildItemIcon(participant.item6),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildParticipantCard(ParticipantDetails participant, String username, String hashtag, List<ParticipantDetails> matchParticipants, int gameDuration, bool isMobile) {
    bool isCurrentUser = (participant.riotIdGameName == username && participant.riotIdTagline == hashtag);
    final minutes = (gameDuration ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameDuration % 60).toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isMobile
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/champion/${participant.championName}.png',
                  width: 60,
                  height: 60,
                ),
                SizedBox(width: 8),
                Text(
                  participant.summonerName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCurrentUser ? Color(0xFFDAA520) : Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Damage per Minute', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(participant.damagePerMinute.toStringAsFixed(1), style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('K/D/A', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text('${participant.kills}/${participant.deaths}/${participant.assists}', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('KDA', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(((participant.kills + participant.assists) / (participant.deaths > 0 ? participant.deaths : 1)).toStringAsFixed(2), style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Minions Killed', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text(participant.totalMinionsKilled.toString(), style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Game Duration', style: TextStyle(color: Colors.white, fontSize: 12)),
                      Text('$minutes:$seconds', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildItemIcon(participant.item0),
                _buildItemIcon(participant.item1),
                _buildItemIcon(participant.item2),
                _buildItemIcon(participant.item3),
                _buildItemIcon(participant.item4),
                _buildItemIcon(participant.item5),
                _buildItemIcon(participant.item6),
              ],
            ),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.network(
                      'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/champion/${participant.championName}.png',
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(width: 8),
                    Text(
                      participant.summonerName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isCurrentUser ? Color(0xFFDAA520) : Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildItemIcon(participant.item0),
                    _buildItemIcon(participant.item1),
                    _buildItemIcon(participant.item2),
                    _buildItemIcon(participant.item3),
                    _buildItemIcon(participant.item4),
                    _buildItemIcon(participant.item5),
                    _buildItemIcon(participant.item6),
                  ],
                ),
              ],
            ),
            Spacer(),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Damage per Minute', style: TextStyle(color: Colors.white, fontSize: 14)),
                            Text(participant.damagePerMinute.toStringAsFixed(1), style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('K/D/A', style: TextStyle(color: Colors.white, fontSize: 14)),
                            Text('${participant.kills}/${participant.deaths}/${participant.assists}', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('KDA', style: TextStyle(color: Colors.white, fontSize: 14)),
                            Text(((participant.kills + participant.assists) / (participant.deaths > 0 ? participant.deaths : 1)).toStringAsFixed(2), style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Minions Killed', style: TextStyle(color: Colors.white, fontSize: 14)),
                            Text(participant.totalMinionsKilled.toString(), style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Game Duration', style: TextStyle(color: Colors.white, fontSize: 14)),
                            Text('$minutes:$seconds', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: List.generate(5, (i) {
                return Row(
                  children: [
                    if (i < matchParticipants.length)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 1.0),
                        child: Image.network(
                          'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/champion/${matchParticipants[i].championName}.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    if (i + 5 < matchParticipants.length)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 1.0),
                        child: Image.network(
                          'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/champion/${matchParticipants[i + 5].championName}.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemIcon(int itemId) {
    if (itemId == 0) return Container();
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.network(
        'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/item/$itemId.png',
        width: 24,
        height: 24,
      ),
    );
  }
}
