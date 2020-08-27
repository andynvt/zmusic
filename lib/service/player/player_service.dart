import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:zmusic/service/network/network_api.dart';

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

  void play(int index, {Function callback}) {
    if (this.index != index) {
      String id = songIds[index];
      Duration p = Duration(milliseconds: 0);
      _downloadFile(NetworkAPI.MUSIC_URL(id), id).then((path) {
        if (callback != null) callback();
        _player.play(path, position: p).then((value) {
          if (value == 1) {
            this.index = index;
            isPlaying = true;
            notifyListeners();
          }
        });
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

  void next() {
    int i = index == songIds.length - 1 ? 0 : index + 1;
    play(i);
  }

  void previous() {
    int i = index == 0 ? songIds.length - 1 : index - 1;
    play(i);
  }

  Future<String> _downloadFile(String url, String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String path = '$dir/$filename.mp3';

    if (await File(path).exists()) {
      return path;
    }
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    File file = new File(path);
    await file.writeAsBytes(bytes);
    return path;
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
