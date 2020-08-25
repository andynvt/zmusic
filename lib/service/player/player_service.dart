import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PlayerService extends ChangeNotifier {
  static PlayerService _sInstance;

  AudioPlayer _player = AudioPlayer();
  Duration duration;
  Duration position;

  bool isPlaying = false;
  String get durationText => _formatDuration(duration);
  String get positionText => _formatDuration(position);
  double get sliderValue {
    if (duration == null || position == null) {
      return 0.0;
    }
    return position.inMilliseconds / duration.inMilliseconds;
  }

  PlayerService._() {
    _initPlayer();
  }

  factory PlayerService.shared() {
    if (_sInstance == null) {
      _sInstance = PlayerService._();
    }
    return _sInstance;
  }

  void _initPlayer() {
    _player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

    _player.onDurationChanged.listen((d) {
      duration = d;
      notifyListeners();
    });

    _player.onAudioPositionChanged.listen((p) {
      position = p;
      notifyListeners();
    });
  }

  void play() {
    Duration p = position == null ? Duration(milliseconds: 0) : position;
    _player.play('https://vpopkaraoke.com/zmusic/s3.mp3', position: p).then((value) {
      if (value == 1) {
        isPlaying = true;
        notifyListeners();
      }
    });
  }

  void pause() {
    _player.pause().then((value) {
      if (value == 1) {
        isPlaying = false;
        notifyListeners();
      }
    });
  }

  void stop() {
    _player.stop();
  }

  void seek() {
    _player.seek(Duration(milliseconds: 1200));
  }

  void resume() {
    _player.resume();
  }

  Future<File> _downloadFile(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  String _formatDuration(Duration duration) {
    if (duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    return '00:00';
  }
}
