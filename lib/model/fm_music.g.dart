// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fm_music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FmMusic _$FmMusicFromJson(Map json) => FmMusic(
      id: json['id'] as int,
      musicInfo: json['musicInfo'] as String,
      createdTime: json['createdTime'] as int,
    );

Map<String, dynamic> _$FmMusicToJson(FmMusic instance) => <String, dynamic>{
      'id': instance.id,
      'musicInfo': instance.musicInfo,
      'createdTime': instance.createdTime,
    };
