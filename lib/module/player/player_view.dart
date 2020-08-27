import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmusic/model/playlist_info.dart';
import 'package:zmusic/model/song_info.dart';
import 'package:zmusic/service/player/player_service.dart';
import 'package:zmusic/service/service.dart';

import 'player_model.dart';

ChangeNotifierProvider<PlayerModel> createPlayer(PlayListInfo info, {int index = 0}) {
  return ChangeNotifierProvider(
    create: (_) => PlayerModel(),
    child: _PlayerView(info: info, index: index),
  );
}

class _PlayerView extends StatefulWidget {
  final PlayListInfo info;
  final int index;

  const _PlayerView({Key key, this.info, this.index}) : super(key: key);
  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<_PlayerView> {
  SongInfo songInfo;
  bool isLoading = true;
  @override
  void initState() {
    String id = widget.info.songIds[widget.index];
    songInfo = DataService.shared().songs[id];
    PlayerService.shared().initPlaylist(widget.info.songIds);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PlayerService.shared().play(widget.index, callback: () {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PlayerModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: ChangeNotifierProvider.value(
              value: PlayerService.shared(),
              child: Consumer<PlayerService>(builder: (_, service, __) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      FlatButton(
                        child: Icon(
                          Icons.arrow_downward,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(height: 8),
                      Container(
                        color: Colors.grey[300],
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        child: Image.network(
                          service.playingSong.cover,
                        ),
                      ),
                      Expanded(
                        child: ChangeNotifierProvider.value(
                          value: PlayerService.shared(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 32),
                              Column(
                                children: [
                                  Text(
                                    service.playingSong.name,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(height: 8),
                                  () {
                                    String artistText = '';
                                    for (int i = 0; i < service.playingSong.artistIds.length; i++) {
                                      final id = service.playingSong.artistIds[i];
                                      final name = DataService.shared().artists[id].name;
                                      artistText += name;
                                      if (i < service.playingSong.artistIds.length - 1) {
                                        artistText += ',';
                                      }
                                      artistText += ' ';
                                    }
                                    return Text(
                                      artistText,
                                      style: const TextStyle(fontSize: 18),
                                    );
                                  }(),
                                ],
                              ),
                              Consumer<PlayerService>(
                                builder: (_, service, __) {
                                  return Row(
                                    children: [
                                      SizedBox(width: 20),
                                      SizedBox(
                                        width: 45,
                                        child: Text(service.positionText ?? ''),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          activeColor: Colors.black,
                                          inactiveColor: Colors.grey,
                                          value: service.sliderValue,
                                          onChanged: PlayerService.shared().seek,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 45,
                                        child: Text(service.durationText ?? ''),
                                      ),
                                      SizedBox(width: 20),
                                    ],
                                  );
                                },
                              ),
                              Consumer<PlayerService>(builder: (_, service, __) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.repeat,
                                        color: service.isRepeat ? Colors.black : Colors.grey,
                                      ),
                                      onPressed: PlayerService.shared().repeat,
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.skip_previous,
                                        size: 30,
                                      ),
                                      onPressed: PlayerService.shared().previous,
                                    ),
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          service.isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                        onPressed: () {
                                          if (service.isPlaying) {
                                            PlayerService.shared().pause();
                                          } else {
                                            PlayerService.shared().resume();
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.skip_next,
                                        size: 30,
                                      ),
                                      onPressed: PlayerService.shared().next,
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.shuffle,
                                        color: service.isShuffle ? Colors.black : Colors.grey,
                                      ),
                                      onPressed: PlayerService.shared().shuffle,
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // NetworkAPI.MUSIC_URL(info.id)
                    ],
                  ),
                );
              }),
            ),
          ),
          isLoading
              ? Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
