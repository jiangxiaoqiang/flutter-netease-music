import 'dart:async';

import '../../netease.dart';

class ScheduleService {
  static void refreshFmCachedMusicCount() {
    Timer.periodic(const Duration(seconds: 10), (Timer t) => neteaseRepository!.appendMusic());
  }
}
