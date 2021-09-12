import 'dart:async';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:netease_music_api/netease_cloud_music.dart' as api;
import 'package:path_provider/path_provider.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:quiet/model/user_detail_bean.dart';
import 'package:quiet/pages/comments/page_comment.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/objects/music_count.dart';
import 'package:quiet/repository/objects/music_video_detail.dart';
import 'package:quiet/repository/reddwarf/reddwarf_music.dart';

export 'package:async/async.dart' show Result;
export 'package:async/async.dart' show ValueResult;
export 'package:async/async.dart' show ErrorResult;
export 'package:quiet/repository/cached_image.dart';
export 'package:quiet/repository/local_cache_data.dart';

import 'package:quiet/model/model.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, RestApiError, RestClient;

class ReddwarfMusic {
  static Future<void> savePlayingMusic(Music music) async {
    try {
      Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/music/user/v1/save-play-record", jsonMap);
      if (RestClient.respSuccess(response)) {}
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
  }

  static Future<void> likePlayingMusic(Music music) async {
    try {
      Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/music/user/v1/like", jsonMap);
      if (RestClient.respSuccess(response)) {}
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
  }

  static Future<List<PlaylistDetail>?> playlist() async {
    try {
      final response = await RestClient.getHttp("/music/playlist/v1/playlist");
      if (RestClient.respSuccess(response)) {
        List reddwarflist = (response.data["result"] as List);
        List<PlaylistDetail> list1 = new List.empty(growable: true);
        reddwarflist.forEach((element) {
          PlaylistDetail? detail = PlaylistDetail.fromMap(element);
          if (detail != null) {
            list1.add(detail);
          }
        });
        return list1;
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return null;
  }

  static Future<Result<PlaylistDetail>?> playlistDetail() async {
    try {
      final response = await RestClient.getHttp("/music/playlist/v1/playlist/detail/1");
      if (RestClient.respSuccess(response)) {
        Map result = (response.data["result"] as Map);
        PlaylistDetail? detail = PlaylistDetail.fromMap(result);
        return Result.value(detail!);
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return null;
  }
}
