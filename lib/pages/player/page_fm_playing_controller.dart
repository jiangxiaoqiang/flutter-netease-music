import 'package:dio/dio.dart';
import 'package:get/get.dart';

class PagePlayingFmController extends GetxController {
  int get queueCount => _queueCount;
  int _queueCount = 0;

  Future<void> updateQueueCount() async {
    _queueCount = await get();
    update();
  }

  Future<int> get() async {
    var dio = Dio();
    var response = await dio.get("http://127.0.0.1:4049");
    return response.data["count"];
  }

  @override
  void onInit() {
    updateQueueCount();
    // TODO: implement onInit
    super.onInit();
  }
}
