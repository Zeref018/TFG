import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tfg/api/get/account_get.dart';
import 'package:tfg/constants/memory.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/models/match_details.dart';
import 'package:tfg/models/queue_data.dart';

part 'match_history_state.dart';

class MatchHistoryCubit extends Cubit<MatchHistoryState> {
  MatchHistoryCubit() : super(MatchHistoryState(pageStatus: PageStatusEnum.loading)) {
    initState();
  }

  Future<void> initState() async {
    String uuid = M.uuid!;
    String? profileIconId = await AccountGetters().getProfileIconId(uuid);

    QueueData? soloQRank = await AccountGetters().getRank(M.accountId!);
    QueueData? flexQRank = await AccountGetters().getRank(M.accountId!, isSoloQ: false);

    List<String>? games = await AccountGetters().getGames(uuid);

    List<MatchDetails>? matchDetails = games != null ? await AccountGetters().getMatchDetails(games) : null;

    emit(state.copyWith(
      pageStatus: PageStatusEnum.loaded,
      soloQRank: soloQRank,
      flexQRank: flexQRank,
      profileIconId: profileIconId,
      matchDetails: matchDetails,
    ));
  }
}
