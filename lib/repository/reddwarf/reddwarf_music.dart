export 'package:async/async.dart' show Result;
export 'package:async/async.dart' show ValueResult;
export 'package:async/async.dart' show ErrorResult;
export 'package:quiet/repository/cached_image.dart';
export 'package:quiet/repository/local_cache_data.dart';

import 'package:quiet/model/model.dart';
import 'package:quiet/model/playlist_detail.dart';
import 'package:wheel/wheel.dart' show GlobalConfig, AppLogHandler, RestApiError, RestClient;

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
        List reddwaflist = (response.data["result"] as List);
        List<PlaylistDetail> list1 = new List.empty(growable: true);
        reddwaflist.forEach((element) {
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
}
