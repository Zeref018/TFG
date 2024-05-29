import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tfg/base_cubit/base_cubit.dart';
import 'package:tfg/constants/custom_colors.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/models/excel_exporter.dart';
import 'package:tfg/widgets/loader.dart';
import 'package:tfg/repositories/preferences_repository.dart';
import 'cubit/match_history_cubit.dart';
import 'package:tfg/models/participant_details.dart';
import 'package:tfg/models/match_details.dart';
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

              if (_expanded.length != state.matchDetails?.length) {
                _expanded =
                List<bool>.filled(state.matchDetails!.length, false);
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
                              if (usernameSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (usernameSnapshot.hasError) {
                                return Text('Error loading username',
                                    style: TextStyle(color: Colors.white));
                              } else {
                                String username = usernameSnapshot.data ?? '';
                                return FutureBuilder<String?>(
                                  future: PreferencesRepository().getHashtag(),
                                  builder: (context, hashtagSnapshot) {
                                    if (hashtagSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (hashtagSnapshot.hasError) {
                                      return Text('Error loading hashtag',
                                          style: TextStyle(
                                              color: Colors.white));
                                    } else {
                                      String hashtag = hashtagSnapshot.data ??
                                          '';
                                      return Column(
                                        children: [
                                          Text(
                                            '$username#$hashtag',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          if (state.matchDetails != null &&
                                              state.matchDetails!.isNotEmpty)
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: state.matchDetails!
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final match = state
                                                    .matchDetails![index];
                                                final currentUserParticipant = match
                                                    .participants.firstWhere(
                                                      (p) =>
                                                  p.riotIdGameName ==
                                                      username &&
                                                      p.riotIdTagline ==
                                                          hashtag,
                                                  orElse: () =>
                                                  match.participants[0],
                                                );
                                                return Card(
                                                  color: currentUserParticipant
                                                      .win
                                                      ? Colors.green[100]
                                                      : Colors.red[100],
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(16.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          'Duration: ${match
                                                              .gameDuration} seconds',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                        SizedBox(height: 8),
                                                        _buildParticipantCard(
                                                            currentUserParticipant,
                                                            username, hashtag, match.participants),
                                                        SizedBox(height: 8),
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _expanded[index] =
                                                              !_expanded[index];
                                                            });
                                                          },
                                                          child: Text(
                                                            _expanded[index]
                                                                ? 'Hide Details'
                                                                : 'Show Details',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueAccent),
                                                          ),
                                                        ),
                                                        if (_expanded[index])
                                                          Column(
                                                            children: _buildParticipantRows(
                                                                match
                                                                    .participants,
                                                                username,
                                                                hashtag),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          if (state.matchDetails == null ||
                                              state.matchDetails!.isEmpty)
                                            Text('No match details available',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ElevatedButton(
                                            onPressed: () {
                                              exportToExcel(
                                                  context, username, hashtag,
                                                  state.matchDetails!);
                                            },
                                            child: Text(
                                              'Download Excel',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .blueAccent,
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

  List<Widget> _buildParticipantRows(List<ParticipantDetails> participants,
      String username, String hashtag) {
    // Ordenar los participantes por posición
    Map<String, ParticipantDetails> orderedParticipants = {};
    for (var participant in participants) {
      orderedParticipants[participant.teamPosition] = participant;
    }

    List<String> positions = ['TOP', 'JUNGLE', 'MIDDLE', 'BOTTOM', 'UTILITY'];
    List<Widget> icons = [];

    for (var position in positions) {
      if (orderedParticipants.containsKey(position)) {
        icons.add(_buildParticipantIcon(orderedParticipants[position]!));
      }
    }

    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(children: icons.sublist(0, 5)),
          SizedBox(width: 16),
          Column(children: icons.sublist(5)),
        ],
      ),
    ];
  }

  Widget _buildParticipantIcon(ParticipantDetails participant) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Image.network(
        'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/champion/${participant.championName}.png',
        width: 32,
        height: 32,
      ),
    );
  }

  Widget _buildParticipantCard(ParticipantDetails participant, String username,
      String hashtag, List<ParticipantDetails> matchParticipants) {
    bool isCurrentUser = (participant.riotIdGameName == username &&
        participant.riotIdTagline == hashtag);

    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(
                    'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/champion/${participant.championName}.png',
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 8),
                  Text(
                    participant.summonerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser ? Color(0xFFDAA520) : Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
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
          Column(
            children: _buildParticipantRows(matchParticipants, username, hashtag),
          ),
        ],
    );
  }

  Widget _buildItemIcon(int itemId) {
    if (itemId == 0) return Container();
    return Image.network(
      'https://ddragon.leagueoflegends.com/cdn/${M.patch}/img/item/$itemId.png',
      width: 32,
      height: 32,
    );
  }
}

