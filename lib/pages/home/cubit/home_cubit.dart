import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tfg/api/get/account_get.dart'; // Importa la clase AccountGetters
import 'package:tfg/constants/memory.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/models/queue_data.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(pageStatus: PageStatusEnum.loading)) {
    initState();
  }

  Future<void> initState() async {
    if (M.accountId == null) {
      emit(state.copyWithProps(pageStatus: PageStatusEnum.logout));
      return;
    }

    // Llama al método para obtener el profileIconId
    String uuid = M.uuid!;
    String? profileIconId = await AccountGetters().getProfileIconId(uuid);

    QueueData? soloQRank = await AccountGetters().getRank(M.accountId!);
    QueueData? flexQRank = await AccountGetters().getRank(M.accountId!, isSoloQ: false);

    emit(state.copyWithProps(pageStatus: PageStatusEnum.loaded, soloQRank: soloQRank, flexQRank: flexQRank, profileIconId: profileIconId));
  }

  Future<void> setLogout() async {
    emit(state.copyWithProps(pageStatus: PageStatusEnum.logout));
  }
}
