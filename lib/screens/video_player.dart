import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quartet/quartet.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer({Key? key, required this.dbItem}) : super(key: key);

  var dbItem;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  String _url = 'https://silatva.com';

  void _launchURL(link) async {
    if (!await launch(link)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    //double _fontSize = 10;
    double _iconSize = 30;
    return Scaffold(
      backgroundColor: Color(0xff264d55),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.dbItem['technique']), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.link),
          tooltip: 'Launch URL',
          onPressed: () {
            _url = widget.dbItem['videoUrl'];
            _launchURL(_url);
          },
        )
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 370,
              child: VimeoPlayer(
                videoId: widget.dbItem['vidID'].toString(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                ListTile(
                  leading: Icon(Icons.sports_kabaddi,
                      color: Colors.white, size: _iconSize),
                  title: Text("Use in Sparring: ${widget.dbItem['useInSparring'] ?? "?"}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.sticky_note_2,
                      color: Colors.white, size: _iconSize),
                  title: Text("Technique Family: ${widget.dbItem['family']}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                if (widget.dbItem['satria_muda'] != "")
                  ListTile(
                    leading: Icon(Icons.calendar_view_day,
                        color: Colors.white, size: _iconSize),
                    title: Text(
                        "Satria Muda: ${titleCase(widget.dbItem['satria_muda'])} Belt - Stripe ${widget.dbItem['sm_stripe']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ListTile(
                  leading: Icon(Icons.table_rows,
                      color: Colors.white, size: _iconSize),
                  title: Text(
                      "Jawara Muda: ${titleCase(widget.dbItem['jawara_muda'])} Belt - Stripe ${widget.dbItem['jm_stripe']}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Divider(color: Colors.white),
                Text("More Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25)),
                SizedBox(height: 10),
                Text(widget.dbItem['desc'], style: TextStyle(
                    color: Colors.white,
                    fontSize: 16))
              ]),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
