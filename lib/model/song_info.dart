import 'package:flutter/material.dart';
import 'package:zmusic/service/service.dart';
import 'model.dart';

class SongInfo extends ChangeNotifier {
  final String id;
  final String name;
  final String cover;
  final String length;
  final List<String> artistIds;

  SongInfo({this.id, this.name, this.cover, this.length, this.artistIds});

  factory SongInfo.from(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final List<dynamic> artistIds = json['artists'] ?? [];
    return SongInfo(
      id: json['id'],
      name: json['name'] ?? '',
      cover: json['cover'] ?? '',
      artistIds: artistIds.cast<String>(),
    );
  }

  static List<SongInfo> fromList(List<dynamic> list) {
    if (list == null) {
      return [];
    }
    return list.map((e) => SongInfo.from(e)).toList();
  }

  ArtistInfo getArtist(String id) {
    return DataService.shared().artists[id];
  }
}
