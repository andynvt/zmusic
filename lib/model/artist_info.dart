import 'package:flutter/material.dart';

class ArtistInfo extends ChangeNotifier {
  final String id;
  final String name;
  final String cover;

  ArtistInfo({this.id, this.name, this.cover});

  factory ArtistInfo.from(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return ArtistInfo(
      id: json['id'],
      name: json['name'],
      cover: json['cover'],
    );
  }

  static List<ArtistInfo> fromList(List<dynamic> list) {
    if (list == null) {
      return [];
    }
    return list.map((e) => ArtistInfo.from(e)).toList();
  }
}
