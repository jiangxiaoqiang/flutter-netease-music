import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
import 'package:quiet/app.dart';
import 'package:quiet/component.dart';
import 'package:quiet/repository/netease.dart';
import 'package:wheel/wheel.dart';

void main() {
  CommonUtils.initialApp(ConfigType.PRO).whenComplete(() => {loadApp(ConfigType.PRO)});
}

/// The entry of dart background service
/// NOTE: this method will be invoked by native (Android/iOS)
/// avoid Tree Shaking
@pragma('vm:entry-point')
void playerBackgroundService() {
  CommonUtils.initialApp(ConfigType.PRO).whenComplete(() => {
    loadRepository()
  });
}

void loadRepository() {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalConfig.init(ConfigType.PRO);
  // 获取播放地址需要使用云音乐 API, 所以需要为此 isolate 初始化一个 repository.
  neteaseRepository = NeteaseRepository();
  runBackgroundService(
    imageLoadInterceptor: BackgroundInterceptors.loadImageInterceptor,
    playUriInterceptor: BackgroundInterceptors.playUriInterceptor,
    playQueueInterceptor: QuietPlayQueueInterceptor(),
  );
}
