part of 'match_history_cubit.dart';

class MatchHistoryState extends Equatable {
  final PageStatusEnum? pageStatus;
  final QueueData? soloQRank;
  final QueueData? flexQRank;
  final String? profileIconId;
  final List<MatchDetails>? matchDetails;

  const MatchHistoryState({
    this.pageStatus,
    this.soloQRank,
    this.flexQRank,
    this.profileIconId,
    this.matchDetails,
  });

  MatchHistoryState copyWith({
    PageStatusEnum? pageStatus,
    QueueData? soloQRank,
    QueueData? flexQRank,
    String? profileIconId,
    List<MatchDetails>? matchDetails,
  }) {
    return MatchHistoryState(
      pageStatus: pageStatus ?? this.pageStatus,
      soloQRank: soloQRank ?? this.soloQRank,
      flexQRank: flexQRank ?? this.flexQRank,
      profileIconId: profileIconId ?? this.profileIconId,
      matchDetails: matchDetails ?? this.matchDetails,
    );
  }

  @override
  List<Object?> get props => [pageStatus, soloQRank, flexQRank, profileIconId, matchDetails];
}
