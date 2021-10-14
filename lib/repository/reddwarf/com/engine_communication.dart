
import 'package:dio/dio.dart';

class EngineCommunication{

  static Future<int> getFmCachedMusicCount() async {
    final dio = Dio();
    final response = await dio.get("http://127.0.0.1:4049");
    return response.data["count"];
  }

}






