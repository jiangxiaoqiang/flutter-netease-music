// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fm_music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FmMusic _$FmMusicFromJson(Map json) => FmMusic(
      id: json['id'] as int,
      musicinfo: json['musicinfo'] as String,
      createdtime: json['createdtime'] as int,
    );

Map<String, dynamic> _$FmMusicToJson(FmMusic instance) => <String, dynamic>{
      'id': instance.id,
      'musicInfo': instance.musicinfo,
      'createdTime': instance.createdtime,
    };
