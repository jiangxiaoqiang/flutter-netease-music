import 'dart:async';
import 'package:quiet/model/model.dart';
import 'package:quiet/part/part.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, AppLoginRequest, Auth, AuthResult, RestApiError, RestClient;
import 'package:wheel/wheel.dart';
export 'package:async/async.dart' show Result;
export 'package:async/async.dart' show ValueResult;
export 'package:async/async.dart' show ErrorResult;
export 'package:quiet/repository/cached_image.dart';
export 'package:quiet/repository/local_cache_data.dart';

class ReddwarfUser {
  static Future<void> login(String username,String password) async {
    try {
      final AppLoginRequest loginRequest = AppLoginRequest(
          loginType: LoginType.PHONE,
          username: username,
          password: password
      );
      AuthResult result = await Auth.loginReq(appLoginRequest: loginRequest);
      var a = 1;
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
