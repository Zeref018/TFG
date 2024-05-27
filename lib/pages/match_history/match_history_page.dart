import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tfg/base_cubit/base_cubit.dart';
import 'package:tfg/constants/custom_colors.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/widgets/loader.dart';
import 'cubit/match_history_cubit.dart';
import 'package:tfg/models/participant_details.dart';  // Importa ParticipantDetails

class MatchHistoryPage extends StatelessWidget {
  const MatchHistoryPage({Key? key}) : super(key: key);

  static const String url = '/match_history/';
  static const String route = '/match_history/';

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

              return Scaffold(
                backgroundColor: CustomColor.get.white,
                appBar: AppBar(
                  title: Text(
                    'Match History',
                    style: TextStyle(
                      color: CustomColor.get.light_pink,
                    ),
                  ),
                  backgroundColor: CustomColor.get.white,
                  elevation: 0,
                  iconTheme: IconThemeData(color: CustomColor.get.light_pink),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          if (state.matchDetails != null)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.matchDetails!.length,
                              itemBuilder: (context, index) {
                                final match = state.matchDetails![index];
                                return Card(
                                  color: match.participants.any((p) => p.win) ? Colors.green[100] : Colors.red[100], // Cambiar el color según el resultado
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Game Mode: ${match.gameMode}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Duration: ${match.gameDuration} seconds',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(height: 8),
                                        ..._buildParticipantRows(match.participants),
                                      ],
                                    ),
                                  ),
                                );
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

  List<Widget> _buildParticipantRows(List<ParticipantDetails> participants) {
    // Agrupar los participantes por su posición
    Map<String, List<ParticipantDetails>> groupedParticipants = {};
    for (var participant in participants) {
      if (!groupedParticipants.containsKey(participant.teamPosition)) {
        groupedParticipants[participant.teamPosition] = [];
      }
      groupedParticipants[participant.teamPosition]!.add(participant);
    }

    // Construir las filas de los participantes
    List<Widget> rows = [];
    groupedParticipants.forEach((position, participants) {
      if (participants.length == 2) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildParticipantCard(participants[0]),
              _buildParticipantCard(participants[1]),
            ],
          ),
        );
      }
    });

    return rows;
  }

  Widget _buildParticipantCard(ParticipantDetails participant) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Champion: ${participant.championName}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'K/D/A: ${participant.kills}/${participant.deaths}/${participant.assists}',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Gold Earned: ${participant.goldEarned}',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Damage Dealt: ${participant.totalDamageDealt}',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Vision Score: ${participant.visionScore}',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Player: ${participant.riotIdGameName}#${participant.riotIdTagline}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
