import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tfg/api/get/account_get.dart';
import 'package:tfg/constants/memory.dart';
import 'package:tfg/enums/page_status_enum.dart';
import 'package:tfg/repositories/preferences_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(usernameInput: TextEditingController(), hashtagInput: TextEditingController()));

  Future<bool> login() async {
    if (state.usernameInput!.text.isEmpty || state.hashtagInput!.text.isEmpty) {
      emit(state.copyWithProps(error: Intl.message('emptyFieldError')));
      return false;
    }
    emit(state.copyWithProps(pageStatus: PageStatusEnum.loading));

    String? uuid = await AccountGetters().getUuid(state.usernameInput!.text, state.hashtagInput!.text);

    if (uuid == null || uuid.isEmpty) {
      emit(state.copyWithProps(error: Intl.message('networkError'), pageStatus: PageStatusEnum.loaded));
      return false;
    } else {
      final preferencesRepository = PreferencesRepository();
      await preferencesRepository.setUuid(uuid);
      M.uuid = uuid;

      // Guardar el username y el hashtag en PreferencesRepository
      await preferencesRepository.setUsername(state.usernameInput!.text);
      await preferencesRepository.setHashtag(state.hashtagInput!.text);

      String? accountId = await AccountGetters().getId(uuid);

      if (accountId != null && accountId.isNotEmpty) {
        await preferencesRepository.setAccountId(accountId);
        M.accountId = accountId;
      } else {
        emit(state.copyWithProps(error: Intl.message('networkError'), pageStatus: PageStatusEnum.loaded));
        return false;
      }
      emit(state.copyWithProps(pageStatus: PageStatusEnum.loaded));
      return true;
    }
  }
}
