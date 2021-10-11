// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fm_music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FmMusic _$MusicFromJson(Map json) {
  return FmMusic(
    id: json['id'] as int,
    musicInfo: json['musicinfo'] as String? ?? '',
    createdTime: json['createdtime'] as int,
  );
}

Map<String, dynamic> _$MusicToJson(FmMusic instance) => <String, dynamic>{
      'id': instance.id,
      'musicinfo': instance.musicInfo,
      'createdtime': instance.createdTime
    };
