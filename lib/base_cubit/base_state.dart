part of 'base_cubit.dart';

class BaseState extends Equatable {
  final PageStatusEnum? pageStatus;
  final String? languageCode;

  const BaseState({this.pageStatus, this.languageCode});

  BaseState copyWithProps({PageStatusEnum? pageStatus, String? languageCode}) {
    return BaseState(
      pageStatus: pageStatus ?? this.pageStatus,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<dynamic> get props => [pageStatus, languageCode];
}
