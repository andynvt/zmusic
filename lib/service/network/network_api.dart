class NetworkAPI {
  NetworkAPI._();

  static const String PLAYLIST = "https://vpopkaraoke.com/zmusic/data.json";
  // ignore: non_constant_identifier_names
  static String MUSIC_URL(String id) {
    return "https://vpopkaraoke.com/zmusic/$id.mp3";
  }
}
