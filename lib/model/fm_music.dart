import 'package:json_annotation/json_annotation.dart';
import 'package:music_player/music_player.dart';

import 'model.dart';

part 'fm_music.g.dart';

@JsonSerializable()
class FmMusic {
  FmMusic({
    required this.id,
    required this.musicInfo,
    required this.createdTime,
  });

  factory FmMusic.fromMetadata(MusicMetadata metadata) {
    return FmMusic.fromJson(metadata.extras!.cast<String, dynamic>());
  }

  factory FmMusic.fromJson(Map<String, dynamic> json) {
    FmMusic music = _$MusicFromJson(json);
    return music;
  }

  final int id;

  final String musicInfo;

  final int createdTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Music && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => _$MusicToJson(this);
}

extension MusicListExt on List<Music> {
  List<MusicMetadata> toMetadataList() {
    return map((e) => e.metadata).toList();
  }
}

extension MusicBuilder on MusicMetadata {
  /// convert metadata to [Music]
  Music toMusic() {
    return Music.fromMetadata(this);
  }
}
