import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer({Key? key, required this.title, required this.videoId})
      : super(key: key);

  final String title;
  var videoId;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff264d55),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 250,
              child: VimeoPlayer(
                videoId: widget.videoId.toString(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Technique Name: Kuda-Kuda Tenga",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Alernate Name: Kuda-Kuda Badak",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Technique Family: Stances",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Can Use During Sparring: Yes",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Notes: Be sure your front foot is forward",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ]
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
