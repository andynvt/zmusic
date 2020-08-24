import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmusic/model/playlist_info.dart';
import 'package:zmusic/service/service.dart';
import '../module.dart';

Widget createHome() {
  return _HomeView();
}

class _HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    DataService.shared().sync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ZMusic',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: DataService.shared(),
          child: Consumer<DataService>(
            builder: (_, service, __) {
              if (service.playlists.values.isEmpty) {
                return Center(
                  child: Text('Empty'),
                );
              }
              final List<PlayListInfo> list = service.playlists.values.toList();
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => createDetail(list[index])),
                      );
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Hero(
                              tag: 'img-${list[index].id}',
                              child: Image.network(
                                list[index].cover,
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.play_circle_outline,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                // width: 40,
                                height: 20,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.play_circle_outline,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      list[index].songIds.length.toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            list[index].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 6),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
