import 'package:wheel/wheel.dart';

import 'app.dart';

void main() {
  CommonUtils.initialApp(ConfigType.PRO).whenComplete(() => {
    loadApp()
  });
}
