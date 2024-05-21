part of 'home_cubit.dart';

class HomeState extends Equatable {
  final PageStatusEnum? pageStatus;
  final QueueData? soloQRank;
  final QueueData? flexQRank;

  const HomeState({this.pageStatus, this.soloQRank, this.flexQRank});

  HomeState copyWithProps({PageStatusEnum? pageStatus, QueueData? soloQRank, QueueData? flexQRank}) {
    return HomeState(
        pageStatus: pageStatus ?? this.pageStatus,
        soloQRank: soloQRank ?? this.soloQRank,
        flexQRank: flexQRank ?? this.flexQRank,
    );
  }

  @override
  List<dynamic> get props => [pageStatus, soloQRank, flexQRank];
}
