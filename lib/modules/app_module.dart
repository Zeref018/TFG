import 'package:flutter_modular/flutter_modular.dart';
import 'package:tfg/modules/home_module.dart';
import 'package:tfg/pages/login/login_page.dart';
import 'package:tfg/pages/match_history/match_history_page.dart'; // Importa la página de historial de partidas

class AppModule extends Module {
  static const String home = '/home/';
  static const String matchHistory = '/match_history/'; // Define la ruta para el historial de partidas

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(LoginPage.route, child: (context) => LoginPage(), transition: TransitionType.rightToLeftWithFade);
    r.module(AppModule.home, module: HomeModule());
    r.child(AppModule.matchHistory, child: (context) => MatchHistoryPage()); // Agrega la ruta para el historial de partidas
  }
}
