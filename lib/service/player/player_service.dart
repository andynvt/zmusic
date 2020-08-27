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

  final List<String> songIds = [];
  int index = -1;
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

  void initPlaylist(List<String> ids) {
    songIds.clear();
    songIds.addAll(ids);
  }

  void play(int index) {
    if (this.index != index) {
      String id = songIds[index];
      Duration p = Duration(milliseconds: 0);
      _player.play('https://vpopkaraoke.com/zmusic/$id.mp3', position: p).then((value) {
        if (value == 1) {
          this.index = index;
          isPlaying = true;
          notifyListeners();
        }
      });
    }
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
    _player.stop().then((value) {
      isPlaying = false;
      notifyListeners();
    });
  }

  void seek(double value) {
    double position = value * duration.inMilliseconds;
    _player.seek(Duration(milliseconds: position.round()));
  }

  void resume() {
    _player.resume().then((value) {
      if (value == 1) {
        isPlaying = true;
        notifyListeners();
      }
    });
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
