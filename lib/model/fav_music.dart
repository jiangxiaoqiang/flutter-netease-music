import 'package:json_annotation/json_annotation.dart';
import 'package:music_player/music_player.dart';

import 'model.dart';

part 'fav.music.g.dart';

@JsonSerializable()
class FavMusic {
  FavMusic({
    required this.id,
    required this.sourceId,
  }) ;

  factory FavMusic.fromMetadata(MusicMetadata metadata) {
    return FavMusic.fromJson(metadata.extras!.cast<String, dynamic>());
  }

  factory FavMusic.fromJson(Map<String, dynamic> json) {
    return _$MusicFromJson(json);
  }

  final int id;

  ///歌曲mv id,当其为0时,表示没有mv
  final int sourceId;

  MusicMetadata? _metadata;

  MusicMetadata get metadata {
    _metadata ??= MusicMetadata(
      mediaId: id.toString(),
      extras: toJson(),
    );
    return _metadata!;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FavMusic && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => _$MusicToJson(this);
}

extension MusicListExt on List<FavMusic> {
  List<MusicMetadata> toMetadataList() {
    return map((e) => e.metadata).toList();
  }
}

extension MusicBuilder on MusicMetadata {
  /// convert metadata to [Music]
  FavMusic toMusic() {
    return FavMusic.fromMetadata(this);
  }
}
