import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmusic/model/playlist_info.dart';
import 'package:zmusic/service/service.dart';

import 'detail_model.dart';

ChangeNotifierProvider<DetailModel> createDetail(PlayListInfo info) {
  return ChangeNotifierProvider(
    create: (_) => DetailModel(),
    child: ChangeNotifierProvider.value(
      value: info,
      child: _DetailView(info: info),
    ),
  );
}

class _DetailView extends StatefulWidget {
  final PlayListInfo info;

  const _DetailView({Key key, this.info}) : super(key: key);
  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  double _width = 0.0;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DetailModel>(context);

    if (_width == 0.0) {
      _width = MediaQuery.of(context).size.width / 2;
    }

    return Consumer<PlayListInfo>(builder: (_, info, __) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            info.name,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 8),
                Container(
                  width: _width,
                  height: _width,
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Hero(
                      tag: 'img-${info.id}',
                      child: Image.network(info.cover),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${info.songIds.length} bài hát',
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        borderRadius: BorderRadius.circular(35),
                        onTap: () {},
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ChangeNotifierProvider.value(
                    value: DataService.shared(),
                    child: Consumer<DataService>(builder: (_, service, __) {
                      return ListView.builder(
                        itemCount: info.songIds.length,
                        itemBuilder: (_, index) {
                          final id = info.songIds[index];
                          final song = service.songs[id];

                          String artistText = '';
                          for (int i = 0; i < song.artistIds.length; i++) {
                            final id = song.artistIds[i];
                            final name = service.artists[id].name;
                            artistText += name;
                            if (i < song.artistIds.length - 1) {
                              artistText += ',';
                            }
                            artistText += ' ';
                          }
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              height: 80,
                              alignment: Alignment.center,
                              child: ListTile(
                                leading: SizedBox(
                                  width: 75,
                                  child: Row(
                                    children: [
                                      Text('${index + 1}'),
                                      SizedBox(width: 8),
                                      Image.network(song.cover),
                                    ],
                                  ),
                                ),
                                title: Text(song.name),
                                subtitle: Text(artistText),
                                trailing: InkWell(
                                  onTap: () {
                                    print('more');
                                  },
                                  child: Container(
                                    width: 45,
                                    height: double.infinity,
                                    child: Icon(Icons.more_horiz),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
