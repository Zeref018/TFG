import 'package:flutter_modular/flutter_modular.dart';
import 'package:tfg/pages/home/home_page.dart';

class HomeModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(HomePage.url, child: (context) => HomePage(), transition: TransitionType.rightToLeftWithFade);
  }
}
