// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavMusic _$MusicFromJson(Map json) {
  return FavMusic(
    id: json['id'] as int,
    sourceId:int.parse(json['source_id']) as int,
  );
}

Map<String, dynamic> _$MusicToJson(FavMusic instance) => <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
    };
