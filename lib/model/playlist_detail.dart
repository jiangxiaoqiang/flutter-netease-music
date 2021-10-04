import 'package:json_annotation/json_annotation.dart';
import 'package:quiet/model/model.dart';
import 'package:quiet/repository/netease.dart';

part 'playlist_detail.g.dart';

@JsonSerializable()
class PlaylistDetail {
  PlaylistDetail({
    required this.id,
    required this.musicList,
    this.creator,
    this.name,
    this.coverUrl,
    required this.trackCount,
    this.description,
    required this.subscribed,
    this.subscribedCount,
    this.commentCount,
    this.shareCount,
    this.playCount,
    required this.trackUpdateTime,
    required this.trackIds,
  });


  ///null when playlist not complete loaded
  @JsonKey(name: 'tracks', defaultValue: [])
  List<Music> musicList;

  @JsonKey(defaultValue: [])
  List<TrackId> trackIds;

  String? name;

  @JsonKey(name: 'coverImgUrl')
  String? coverUrl;

  int id;

  int trackCount;

  String? description;

  @JsonKey(defaultValue: false)
  bool subscribed;

  int? subscribedCount;

  int? commentCount;

  int? shareCount;

  int? source;

  int? playCount;

  bool get loaded => trackCount == 0 || (musicList != null && musicList!.length == trackCount);

  @JsonKey(defaultValue: 0)
  int trackUpdateTime;

  ///tag fro hero transition
  String get heroTag => "playlist_hero_$id";

  ///
  /// properties:
  /// avatarUrl , nickname
  ///
  final Map<String, dynamic>? creator;

  factory PlaylistDetail.fromJson(Map playlist) {
    return _$PlaylistDetailFromJson(playlist);
  }

  static PlaylistDetail? fromMap(Map? map) {
    if (map == null) {
      return null;
    }
    List<Music>? musicList = (map['musicList'] as List?)?.cast<Map<String, dynamic>>().map((m) => Music.fromJson(m)).cast<Music>().toList();
    return PlaylistDetail(
        id: map['id'],
        musicList: musicList!,
        creator:map['creator'],
        name:map['name'],
        coverUrl:map['coverUrl'],
        trackCount:map['trackCount'],
        description:map['description'],
        subscribed:map['subscribed'],
        subscribedCount:map['subscribedCount'],
        commentCount:map['commentCount'],
        shareCount:map['shareCount'],
        //source: map['source'],
        playCount:map['playCount'],
        trackUpdateTime: map['trackUpdateTime'],
        trackIds: map['trackIds']);
  }

  Map toMap() {
    return {
      'id': id,
      'musicList': musicList?.map((m) => m.toJson()).toList(),
      'creator': creator,
      'name': name,
      'coverUrl': coverUrl,
      'trackCount': trackCount,
      'description': description,
      'subscribed': subscribed,
      'subscribedCount': subscribedCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'source': source,
      'playCount': playCount
    };
  }

  Map toJson() => _$PlaylistDetailToJson(this);
}

@JsonSerializable()
class TrackId {
  TrackId({
    required this.id,
    required this.v,
    required this.t,
    required this.at,
    required this.uid,
    required this.rcmdReason,
  });

  factory TrackId.fromJson(Map json) => _$TrackIdFromJson(json);

  final int id;
  final int v;
  final int t;
  final int at;
  final int uid;
  final String rcmdReason;

  Map<String, dynamic> toJson() => _$TrackIdToJson(this);
}
