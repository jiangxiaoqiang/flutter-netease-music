import 'package:get/get.dart';
import 'package:quiet/repository/reddwarf/db/fm_music_queue.dart';

class PagePlayingFmController extends GetxController {
  int get queueCount => _queueCount;
  int _queueCount = 0;

  Future<void> updateQueueCount() async {
    _queueCount = await FmMusicQueue.getFmCachedMusicCount();
    update();
  }

  @override
  void onInit() {
    updateQueueCount();
    // TODO: implement onInit
    super.onInit();
  }
}
