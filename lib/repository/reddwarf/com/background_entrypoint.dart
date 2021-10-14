
import 'dart:convert';
import 'dart:io';

import 'package:quiet/repository/reddwarf/db/fm_music_queue.dart';

class BackgroundEntrypoint{

   static void serviceStart() async {
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
            final int musicCount = await FmMusicQueue.getFmCachedMusicCount();
            request.response
              ..headers.contentType = ContentType.json
              ..write(json.encode({
                "id": "idxxxxxx",
                "title": "GET  response ",
                "count": musicCount
              }))
              ..close();
            break;
        }
      });
    });
  }

}



