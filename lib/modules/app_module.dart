import 'package:flutter_modular/flutter_modular.dart';
import 'package:tfg/modules/home_module.dart';
import 'package:tfg/pages/login/login_page.dart';

class AppModule extends Module {
  static const String home = '/home/';

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(LoginPage.route, child: (context) => LoginPage(), transition: TransitionType.rightToLeftWithFade);
    r.module(AppModule.home, module: HomeModule());
  }
}
