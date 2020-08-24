import 'package:flutter/material.dart';
import 'package:zmusic/model/model.dart';
import '../service.dart';

class DataService extends ChangeNotifier {
  static DataService _sInstance;

  final Map<String, PlayListInfo> playlists = {};
  final Map<String, SongInfo> songs = {};
  final Map<String, ArtistInfo> artists = {};

  DataService._();

  factory DataService.shared() {
    if (_sInstance == null) {
      _sInstance = DataService._();
    }
    return _sInstance;
  }

  void sync() {
    syncPlaylist();
  }

  void syncPlaylist() {
    void fillData(Map<String, dynamic> data) {
      if (data == null) {
        return;
      }
      playlists.clear();
      playlists.addAll(data['playlists']);
      songs.clear();
      songs.addAll(data['songs']);
      artists.clear();
      artists.addAll(data['artists']);

      notifyListeners();
    }

    NetworkService.shared().sendGETRequest(
      url: NetworkAPI.PLAYLIST,
      parser: NetworkParser.playlistParser,
      callback: (rs) {
        if (!rs.isOK) {
          Future.delayed(Duration(seconds: 3), syncPlaylist);
          return;
        }
        fillData(rs.data);
      },
    );
  }
}
