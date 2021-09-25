import 'dart:async';
import 'dart:convert';
import 'package:quiet/model/model.dart';
import 'package:quiet/part/part.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, AppLoginRequest, Auth, AuthResult, RestApiError, RestClient;
import 'package:wheel/wheel.dart';
export 'package:async/async.dart' show Result;
export 'package:async/async.dart' show ValueResult;
export 'package:async/async.dart' show ErrorResult;
export 'package:quiet/repository/cached_image.dart';
export 'package:quiet/repository/local_cache_data.dart';

class ReddwarfTemp {
  static Future<int> getPatchMusic() async {
    try {
      final response = await RestClient.getHttp("/music/songs/v1/patch");
      if (RestClient.respSuccess(response)) {
        final List music = response.data["result"] ;
        Map<String,dynamic> musicItem = music.first;
        int intid = musicItem["source_id"];
        return intid;
      }
    } on Exception catch (e) {
      // only executed if error is of type Exception
      AppLogHandler.logError(RestApiError("type exception http error"), "type exception http error");
    } catch (error) {
      // executed for errors of all types other than Exception
      AppLogHandler.logError(RestApiError("http error"), "type exception http error");
    }
    return -1;
  }

  static Future<void> savePatchMusic(Music music) async {
    try {
      Map jsonMap = music.toJson();
      final response = await RestClient.postHttp("/music/songs/v1/patch/update",jsonMap);
      if (RestClient.respSuccess(response)) {

      }
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
}
