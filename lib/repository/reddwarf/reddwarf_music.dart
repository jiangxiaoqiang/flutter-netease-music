import 'dart:async';

import 'package:quiet/model/model.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/reddwarf/reddwarf_music.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, RestApiError, RestClient;

export 'package:async/async.dart' show Result;
export 'package:async/async.dart' show ValueResult;
export 'package:async/async.dart' show ErrorResult;
export 'package:quiet/repository/cached_image.dart';
export 'package:quiet/repository/local_cache_data.dart';

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

  static Future<bool> legacyMusic(Music music) async {
    try {
      final response = await RestClient.getHttp("/music/songs/v1/jump/"+music.id.toString());
      if (RestClient.respSuccess(response)) {
        final Object isLegacyMusic = response.data["result"] ;
        return isLegacyMusic.toString().toLowerCase() == 'true';
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return false;
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

  static Future<void> incrementPlayCount(Music music) async {
    try {
      Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/songs/v1/playcount/increment/" + music.id.toString(), jsonMap);
      if (RestClient.respSuccess(response)) {}
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
  }

  static Future<void> dislikePlayingMusic(Music music) async {
    try {
      Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/music/user/v1/dislike", jsonMap);
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
