import 'package:flutter/material.dart';
import 'package:tfg/base_cubit/base_cubit.dart';
import 'package:tfg/constants/memory.dart';
import 'package:tfg/modules/app_module.dart';
import 'package:tfg/pages/home/home_page.dart';
import 'package:tfg/pages/match_history/match_history_page.dart'; // Importa la página de historial de partidas
import 'package:tfg/repositories/preferences_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferencesRepository = PreferencesRepository();
  await preferencesRepository.initSession();

  if (M.accountId != null && M.accountId!.isNotEmpty) {
    Modular.setInitialRoute(HomePage.route);
  }

  runApp(ModularApp(
    module: AppModule(),
    child: BlocProvider(
      create: (context) => BaseCubit(),
      child: BlocBuilder<BaseCubit, BaseState>(
        builder: (context, state) {
          return BaseApp();
        },
      ),
    ),
  ));
}

class BaseApp extends StatelessWidget {
  const BaseApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: Locale(M.languageCode),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: Intl.message('baseApp'),
    );
  }
}
