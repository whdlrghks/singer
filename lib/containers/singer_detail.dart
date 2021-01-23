import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import './sing_item.dart';

class Singer_Detail extends StatefulWidget {
  final String singer;
  const Singer_Detail({Key key, @required this.singer}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Singer_DetailState(singer);
}

class Singer_DetailState extends State<Singer_Detail> {
  final String singer;
  List<Sing_item> _list = List();
  Singer_DetailState(this.singer);
  String pre_videoURL =
      "https://www.youtube.com/watch?v=oxsBSCf5-B8&list=RDoxsBSCf5-B8&start_radio=1";
  List<String> _urllists = List();
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;
  YoutubePlayerController _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(pre_videoURL),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        // loop: true,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void listener() {
    if (_isPlayerReady == _controller.value.isFullScreen) {
      setState(() {
        _controller.play();
        _isPlayerReady = _controller.value.isFullScreen;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  Widget show_song_list() {
    // firebase랑 통신해서 해당 가수의 노래 제목과 url 가져오기
    Sing_item newthing = Sing_item(singer, "노래제목", "https://url.com");

    _list.add(newthing);

    return Container(
        child: ListView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        // if (index > _list.length) url 더 요청
        if (index < _list.length) {
          return Card(
              child: new InkWell(
            // onTap: ,
            child: Row(
              children: <Widget>[
                //thumbnail
                Image.network(
                  'https://img.youtube.com/vi/6cwnBBAVIwE/default.jpg',
                  fit: BoxFit.cover,
                ),
                //information
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // singer
                      Text(
                        _list[index].singer,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 23.0, fontWeight: FontWeight.w300),
                      ),
                      // title
                      Text(_list[index].sing_title,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 17.0)),
                    ],
                  ),
                )),
                // play icon button
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: _isPlayerReady
                      ? () {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                          setState(() {});
                        }
                      : null,
                  alignment: Alignment.centerRight,
                )
              ],
            ),
            // onTap: ,
          ));
        }
      },
    ));
  }

  // Widget show_video_list(){
  //   // firebase랑 통신해서 해당 가수의 영상 제목과 url 가져오기
  //   return ;
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("$singer"),
        ),
        body: SafeArea(
            child: Column(
          children: [
            // main youtube player
            YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
                onReady: () {
                  _controller.addListener(listener);
                  _isPlayerReady = true;
                },
              ),
              builder: (context, player) => player,
            ),
            //show playing video information.
            Column(
              children: [
                Container(
                    color: Colors.blueGrey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 가수 이름
                        Expanded(
                            flex: 2,
                            child: Container(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  "$singer",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                ))),
                        // 노래
                        Expanded(
                          flex: 5,
                          child: Container(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "노래제목",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 20.0),
                              )),
                        ),
                        // 플레이 / pause
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: _isPlayerReady
                              ? () {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                  setState(() {});
                                }
                              : null,
                          alignment: Alignment.centerRight,
                        )
                      ],
                    )),
                show_song_list(),
              ],
            )
          ],
        )));
  }
}
