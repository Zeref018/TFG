part of 'home_cubit.dart';

class HomeState extends Equatable {
  final PageStatusEnum? pageStatus;
  final QueueData? soloQRank;
  final QueueData? flexQRank;
  final String? profileIconId; // Agrega la propiedad profileIconId

  const HomeState({this.pageStatus, this.soloQRank, this.flexQRank, this.profileIconId}); // Actualiza el constructor

  HomeState copyWithProps({PageStatusEnum? pageStatus, QueueData? soloQRank, QueueData? flexQRank, String? profileIconId}) {
    return HomeState(
      pageStatus: pageStatus ?? this.pageStatus,
      soloQRank: soloQRank ?? this.soloQRank,
      flexQRank: flexQRank ?? this.flexQRank,
      profileIconId: profileIconId ?? this.profileIconId, // Actualiza la copia del estado
    );
  }

  @override
  List<dynamic> get props => [pageStatus, soloQRank, flexQRank, profileIconId]; // Añade profileIconId a la lista de propiedades
}
