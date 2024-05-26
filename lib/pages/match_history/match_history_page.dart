import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tfg/base_cubit/base_cubit.dart';
import 'package:tfg/constants/custom_colors.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/widgets/loader.dart';
import 'cubit/match_history_cubit.dart';

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
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Match History',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CustomColor.get.light_pink,
                            ),
                          ),
                          SizedBox(height: 20),
                          if (state.matchDetails != null)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.matchDetails!.length,
                              itemBuilder: (context, index) {
                                final match = state.matchDetails![index];
                                return ListTile(
                                  title: Text('Champion: ${match.championName}'),
                                  subtitle: Text('K/D/A: ${match.kills}/${match.deaths}/${match.assists}\nGold Earned: ${match.goldEarned}\nDamage Dealt: ${match.totalDamageDealt}\nVision Score: ${match.visionScore}'),
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
}
