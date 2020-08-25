import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmusic/model/song_info.dart';
import 'package:zmusic/service/player/player_service.dart';
import 'package:zmusic/service/service.dart';

import 'player_model.dart';

ChangeNotifierProvider<PlayerModel> createPlayer(SongInfo songInfo) {
  return ChangeNotifierProvider(
    create: (_) => PlayerModel(),
    child: ChangeNotifierProvider.value(
      value: songInfo,
      child: _PlayerView(info: songInfo),
    ),
  );
}

class _PlayerView extends StatefulWidget {
  final SongInfo info;

  const _PlayerView({Key key, this.info}) : super(key: key);
  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<_PlayerView> {
  @override
  void initState() {
    PlayerService.shared().play();
    super.initState();
  }

  @override
  void dispose() {
    PlayerService.shared().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PlayerModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<SongInfo>(builder: (_, info, __) {
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
                    info.cover,
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
                              info.name,
                              style: const TextStyle(fontSize: 24),
                            ),
                            SizedBox(height: 8),
                            () {
                              String artistText = '';
                              for (int i = 0; i < info.artistIds.length; i++) {
                                final id = info.artistIds[i];
                                final name = DataService.shared().artists[id].name;
                                artistText += name;
                                if (i < info.artistIds.length - 1) {
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
                                    onChanged: (v) {},
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.repeat),
                              onPressed: () {},
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.skip_previous,
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Consumer<PlayerService>(builder: (_, service, __) {
                                return IconButton(
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
                                      PlayerService.shared().play();
                                    }
                                  },
                                );
                              }),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.skip_next,
                                size: 30,
                              ),
                              onPressed: () {
                                PlayerService.shared().stop();
                              },
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.shuffle),
                              onPressed: () {},
                            ),
                          ],
                        ),
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
    );
  }
}
