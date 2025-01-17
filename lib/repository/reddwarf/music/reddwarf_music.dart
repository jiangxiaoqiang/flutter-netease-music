import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:quiet/model/fav_music.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:quiet/part/part.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, RestApiError, RestClient;

import '../../netease.dart';

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
      } else {
        AppLogHandler.logError(RestApiError("http error"), "type exception http error");
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
      if (RestClient.respSuccess(response)) {
      } else {}
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
      final response = await RestClient.getHttp("/music/songs/v1/collect/${music.id}");
      if (RestClient.respSuccess(response)) {
        final List isLegacyMusic = response.data["result"] as List;
        if (isLegacyMusic.isEmpty) {
          return false;
        }
        final FavMusic item = FavMusic.fromJson(isLegacyMusic[0]);
        if (item.like_status == 1) {
          final int songId = item.sourceId;
          neteaseRepository!.like(songId, like: true);
          return true;
        }
        if (item.like_status == -1) {
          final int songId = item.sourceId;
          neteaseRepository!.fmTrash(songId);
          return true;
        }
        return false;
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

  static Future<bool> likePlayingMusic(Music music, int likeStatus) async {
    try {
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      final Map jsonMap = music.toJson();
      jsonMap.putIfAbsent("timeStamp", () => currentTimestamp);
      jsonMap.putIfAbsent("like_status", () => likeStatus);
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
      final Map jsonMap = new HashMap();
      final response = await RestClient.postHttp("/music/songs/v1/playcount/increment/${music.id}", jsonMap);
      if (RestClient.respSuccess(response)) {
        return result;
      }
    } on Exception catch (e) {
      result = e.toString();
      AppLogHandler.logErrorException("mark songs error", e);
    } catch (error) {
      result = error.toString();
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return result;
  }

  static Future<bool> dislikePlayingMusic(Music music) async {
    try {
      final Map jsonMap = music.toJson();
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      jsonMap.putIfAbsent("timeStamp", () => currentTimestamp);
      jsonMap.putIfAbsent("like_status", () => -1);
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
        final String result = response.data["result"];
        final List<int> ids = List.empty(growable: true);
        final lists = json.decode(result);
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
