import 'package:json_annotation/json_annotation.dart';
import 'package:music_player/music_player.dart';

import 'model.dart';

part 'fm_music.g.dart';

@JsonSerializable()
class FmMusic {
  FmMusic({
    required this.id,
    required this.musicinfo,
    required this.createdtime,
  });

  factory FmMusic.fromMetadata(MusicMetadata metadata) {
    return FmMusic.fromJson(metadata.extras!.cast<String, dynamic>());
  }

  factory FmMusic.fromJson(Map<String, dynamic> json) {
    FmMusic music = _$FmMusicFromJson(json);
    return music;
  }

  final int id;

  final String musicinfo;

  final int createdtime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Music && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => _$FmMusicToJson(this);
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
