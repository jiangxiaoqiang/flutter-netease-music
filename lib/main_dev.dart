import 'package:flutter/cupertino.dart';
import 'package:music_player/music_player.dart';
import 'package:quiet/repository/netease.dart';
import 'package:wheel/wheel.dart';

import 'app.dart';
import 'component/player/interceptors.dart';

void main() {
  CommonUtils.initialApp(ConfigType.DEV).whenComplete(() => {
    loadApp()
  });
}

/// The entry of dart background service
/// NOTE: this method will be invoked by native (Android/iOS)
@pragma('vm:entry-point') // avoid Tree Shaking
void playerBackgroundService() {
  WidgetsFlutterBinding.ensureInitialized();
  // 获取播放地址需要使用云音乐 API, 所以需要为此 isolate 初始化一个 repository.
  neteaseRepository = NeteaseRepository();
  runBackgroundService(
    imageLoadInterceptor: BackgroundInterceptors.loadImageInterceptor,
    playUriInterceptor: BackgroundInterceptors.playUriInterceptor,
    playQueueInterceptor: QuietPlayQueueInterceptor(),
  );
}
