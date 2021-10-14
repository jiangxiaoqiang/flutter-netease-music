import 'package:get/get.dart';
import 'package:quiet/repository/reddwarf/com/engine_communication.dart';

class PagePlayingFmController extends GetxController {
  int get queueCount => _queueCount;
  int _queueCount = 0;

  Future<void> updateQueueCount() async {
    _queueCount = await EngineCommunication.getFmCachedMusicCount();
    update();
  }

  @override
  void onInit() {
    updateQueueCount();
    // TODO: implement onInit
    super.onInit();
  }
}
