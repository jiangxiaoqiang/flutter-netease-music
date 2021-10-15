import 'dart:async';
import 'dart:convert';

import 'package:quiet/model/fav_music.dart';
import 'package:quiet/model/model.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/reddwarf/music/reddwarf_music.dart';
import 'package:quiet/repository/reddwarf/temp/reddwarf_temp.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, RestApiError, RestClient;

export 'package:async/async.dart' show Result, ValueResult, ErrorResult;
export 'package:quiet/repository/cached_image.dart';
export 'package:quiet/repository/local_cache_data.dart';

class ReddwarfMusic {
  static Future<void> savePlayingMusicList(List<Music>? musics) async {
    if (musics == null) {
      return;
    }
    for (final element in musics) {
      _savePlayingMusic(element);
    }
  }

  static Future<void> _savePlayingMusic(Music music) async {
    try {
      final response = await RestClient.getHttp("/music/songs/v1/exists/${music.id}");
      if (RestClient.respSuccess(response)) {
        final Object isLegacyMusic = response.data["result"];
        if (isLegacyMusic.toString().toLowerCase() == 'false') {
          ReddwarfMusic._savePlayingMusicImpl(music);
        }
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), e.toString());
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
  }

  static Future<void> _savePlayingMusicImpl(Music music) async {
    try {
      final Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/music/user/v1.1/save-play-record", jsonMap);
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
      final response = await RestClient.getHttp("/music/songs/v1/jump/${music.id}");
      if (RestClient.respSuccess(response)) {
        final Object isLegacyMusic = response.data["result"];
        return isLegacyMusic.toString().toLowerCase() == 'true';
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), e.toString());
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), error.toString());
    }
    return true;
  }

  static Future<bool> likePlayingMusic(Music music) async {
    try {
      final Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/music/user/v1.1/like", jsonMap);
      if (RestClient.respSuccess(response)) {
        return true;
      }
    } on Exception catch (e) {
      AppLogHandler.logError(RestApiError("type exception http error"), e.toString());
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), error.toString());
    }
    return false;
  }

  static Future<String> incrementPlayCount(Music music) async {
    String result = "ok";
    try {
      final Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/songs/v1/playcount/increment/${music.id}", jsonMap);
      if (RestClient.respSuccess(response)) {
        return result;
      }
    } on Exception catch (e) {
      result = e.toString();
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      result = error.toString();
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return result;
  }

  static Future<bool> dislikePlayingMusic(Music music) async {
    try {
      final Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/music/user/v1.1/dislike", jsonMap);
      if (RestClient.respSuccess(response)) {
        return true;
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), e.toString());
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return false;
  }

  static Future<List<PlaylistDetail>?> playlist() async {
    try {
      final response = await RestClient.getHttp("/music/playlist/v1/playlist");
      if (RestClient.respSuccess(response)) {
        final List reddwarfList = response.data["result"] as List;
        final List<PlaylistDetail> playListResult = List.empty(growable: true);
        for (final element in reddwarfList) {
          final PlaylistDetail? detail = PlaylistDetail.fromMap(element);
          if (detail != null) {
            playListResult.add(detail);
          }
        }
        return playListResult;
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), e.toString());
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), error.toString());
    }
    return null;
  }

  static Future<Result<PlaylistDetail>?> playlistDetail(int id) async {
    try {
      final response = await RestClient.getHttp("/music/playlist/v1.1/playlist/detail/$id");
      if (RestClient.respSuccess(response)) {
        final Map result = response.data["result"] as Map;
        final PlaylistDetail? detail = PlaylistDetail.fromMap(result);
        return Result.value(detail!);
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), e.toString());
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return null;
  }

  static Future<Result<List<int>>?> likeMusicIdList() async {
    try {
      final response = await RestClient.getHttp("/music/user/v1/fav/list");
      if (RestClient.respSuccess(response)) {
        String result = response.data["result"];
        List<int> ids = List.empty(growable: true);
        var lists = json.decode(result);
        lists.forEach((element) {
          FavMusic favMusic = FavMusic.fromJson(element);
          ids.add(favMusic.sourceId);
        });
        return Result.value(ids);
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), e.toString());
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return null;
  }
}
