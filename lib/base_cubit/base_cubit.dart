import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tfg/constants/memory.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/generated/intl/messages_all.dart';

part 'base_state.dart';

class BaseCubit extends Cubit<BaseState> {
  BaseCubit() : super(BaseState(pageStatus: PageStatusEnum.loading)) {
    initState();
  }

  Future<void> initState() async {
    await initializeMessages(M.languageCode);
    emit(state.copyWithProps(pageStatus: PageStatusEnum.loaded, languageCode: M.languageCode));
  }

  void setLoading() {
    emit(state.copyWithProps(pageStatus: PageStatusEnum.loading));
  }
}
