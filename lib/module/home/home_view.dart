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
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
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
                        Hero(
                          tag: 'img-${list[index].id}',
                          child: Image.network(
                            list[index].cover,
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            list[index].name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
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
