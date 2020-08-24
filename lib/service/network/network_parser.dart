import 'package:zmusic/model/artist_info.dart';
import 'package:zmusic/model/playlist_info.dart';
import 'package:zmusic/model/song_info.dart';

typedef ParseCallback = Map<String, dynamic> Function(dynamic);

class NetworkParser {
  NetworkParser._();

  static Map<String, dynamic> playlistParser(dynamic json) {
    if (json is Map<String, dynamic> && json.isNotEmpty) {
      final Map<String, dynamic> result = {};
      final Map<String, ArtistInfo> artists = Map.fromIterable(
        json['artists'],
        key: (e) => e['id'],
        value: (e) => ArtistInfo.from(e),
      );
      final Map<String, SongInfo> songs = Map.fromIterable(
        json['songs'],
        key: (e) => e['id'],
        value: (e) => SongInfo.from(e),
      );
      final Map<String, PlayListInfo> playlists = Map.fromIterable(
        json['playlists'],
        key: (e) => e['id'],
        value: (e) => PlayListInfo.from(e),
      );

      result['artists'] = artists;
      result['songs'] = songs;
      result['playlists'] = playlists;
      return result;
    }
    return {};
  }
}
