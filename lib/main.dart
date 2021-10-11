import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
import 'package:quiet/app.dart';
import 'package:quiet/component.dart';
import 'package:quiet/component/global/netease_global_config.dart';
import 'package:quiet/repository/netease.dart';
import 'package:quiet/repository/reddwarf/db/fm_music_queue.dart';
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
  neteaseRepository = NeteaseRepository();
  Timer.periodic(const Duration(seconds: 10), (Timer t) => neteaseRepository!.appendMusic());
  serviceStart();
  runBackgroundService(
    imageLoadInterceptor: BackgroundInterceptors.loadImageInterceptor,
    playUriInterceptor: BackgroundInterceptors.playUriInterceptor,
    playQueueInterceptor: QuietPlayQueueInterceptor(),
  );
}

void serviceStart() async {
  HttpServer.bind(InternetAddress.anyIPv4, 4049, shared: true).then((service) {
    print("service  ${service.address}  ${service.port}");
    service.listen((request) async {
      print(request.uri);
      switch (request.method) {
        case "POST":
          var result = await request
              .cast<List<int>>()
              .transform(utf8.decoder)
              .join()
              .then(json.decode);
          print("POST   $request");
          request.response
            ..headers.contentType = ContentType.json
            ..write(json.encode({
              "id": "sssss",
              "title": "response  hello  post",
            }))
            ..close();
          break;
        case "GET":
          int musicCount = await FmMusicQueue.getCount();
          request.response
            ..headers.contentType = ContentType.json
            ..write(json.encode({
              "id": "idxxxxxx",
              "title": "GET  response ",
              "count":musicCount
            }))
            ..close();
          break;
      }
    });
  });
}
