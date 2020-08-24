import 'package:flutter/material.dart';
import 'package:zmusic/service/service.dart';
import 'model.dart';

class PlayListInfo extends ChangeNotifier {
  final String id;
  final String name;
  final String cover;
  final List<String> songIds;

  PlayListInfo({this.id, this.name, this.cover, this.songIds});

  factory PlayListInfo.from(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final List<dynamic> songIds = json['songs'] ?? [];

    return PlayListInfo(
      id: json['id'],
      name: json['name'] ?? '',
      cover: json['cover'] ?? '',
      songIds: songIds.cast<String>(),
    );
  }

  static List<PlayListInfo> fromList(List<dynamic> ls) {
    if (ls == null) {
      return [];
    }
    return ls.map((e) => PlayListInfo.from(e)).toList();
  }

  SongInfo getSong(String id) {
    return DataService.shared().songs[id];
  }
}
