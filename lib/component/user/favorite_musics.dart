import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiet/component.dart';
import 'package:quiet/model/model.dart';
import 'package:quiet/part/part.dart';
import 'package:quiet/repository/netease.dart';
import 'package:quiet/repository/reddwarf/music/reddwarf_music.dart';

final userFavoriteMusicListProvider = StateNotifierProvider<UserFavoriteMusicListNotifier, List<int>>(
  (ref) => UserFavoriteMusicListNotifier(ref.watch(userProvider).userId),
);

class UserFavoriteMusicListNotifier extends CacheableStateNotifier<List<int>> {
  UserFavoriteMusicListNotifier(this.userId) : super(const []);

  static const _keyLikedSongList = 'likedSongList';

  final int? userId;

  /// 红心歌曲
  Future<void> likeMusic(Music music, int likeStatus) async {
    final bool succeed = await ReddwarfMusic.likePlayingMusic(music, likeStatus);
    if (succeed) {
      if (likeStatus == 1) {
        state = [...state, music.id];
      }
      if (likeStatus == 0) {
        state = List.from(state)..remove(music.id);
      }
    }
    neteaseRepository!.like(music.id, like: true);
  }

  ///不喜欢歌曲
  Future<void> dislikeMusic(Music music) async {
    final succeed = await ReddwarfMusic.dislikePlayingMusic(music);
    if (succeed) {
      state = List.from(state)..remove(music.id);
    }
    neteaseRepository!.like(music.id, like: false);
  }

  @override
  Future<List<int>?> load() async {
    final value = await neteaseRepository!.likedList(userId);
    if (value.isValue) {
      return value.asValue!.value;
    }
    return null;
  }

  @override
  Future<List<int>?> loadFromCache() async => (await neteaseLocalData[_keyLikedSongList] as List?)?.cast<int>();

  @override
  void saveToCache(List<int> value) {
    neteaseLocalData[_keyLikedSongList] = value;
  }
}

final musicIsFavoriteProvider = Provider.family<bool, Music>((ref, music) {
  return ref.watch(userFavoriteMusicListProvider).contains(music.id);
});
