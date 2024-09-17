import 'package:flutter/material.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioVideoPage extends StatefulWidget {
  AudioVideoPage({Key? key, required this.dbItem}) : super(key: key);

  var dbItem;

  @override
  _AudioVideoPageState createState() => _AudioVideoPageState();
}

class _AudioVideoPageState extends State<AudioVideoPage> {
  String _url = 'https://silatva.com';
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double currentPosition = 0.0;
  Duration duration = Duration.zero;
  bool hasAudio = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        currentPosition = newPosition.inMilliseconds.toDouble();
      });
    });
    audioPlayer.onPlayerStateChanged.listen((playerState) {
      setState(() {
        isPlaying = playerState == PlayerState.playing;
      });
    });
    // Fetch the MP3 URL once on initialization
    getMP3URL();
  }

  Future<String> getMP3URL() async {
    Reference storageReference = FirebaseStorage.instance.ref().child(widget.dbItem['audio']);
    final downloadURL = await storageReference.getDownloadURL();
    setState(() {
      hasAudio = true;
    });
    return downloadURL;
  }

  void togglePlay() async {
    String url = await getMP3URL();
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.setSourceUrl(url);
      await audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void seek(double position) {
    audioPlayer.seek(Duration(milliseconds: position.round()));
  }

  @override
  void dispose() {
    if (isPlaying) {
      audioPlayer.stop(); // Ensure audio is stopped
    }

    audioPlayer.release(); // Release the resources
    audioPlayer.dispose(); // Dispose the AudioPlayer object
    super.dispose();
  }

  void _launchURL(String link) async {
    if (!await launch(link)) throw 'Could not launch $link';
  }

  @override
  Widget build(BuildContext context) {
    double _iconSize = 30;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dbItem['technique']),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.link),
            tooltip: 'Launch URL',
            onPressed: () {
              _url = widget.dbItem['videoUrl'];
              _launchURL(_url);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 250,
              child: VimeoPlayer(
                videoId: '${widget.dbItem['vidID'].toString()}?h=${widget.dbItem['hash'].toString()}#',
              ),
            ),
            hasAudio ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: togglePlay,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text("Pronunciation: ${widget.dbItem['technique']}", style: TextStyle(fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                Slider(
                  value: currentPosition,
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      currentPosition = value;
                    });
                    seek(value);
                  },
                ),
              ],
            ) : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.sports_kabaddi, color: Colors.white, size: _iconSize),
                    title: Text("Use in Sparring: ${widget.dbItem['useInSparring'] ?? "?"}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  ListTile(
                    leading: Icon(Icons.sticky_note_2, color: Colors.white, size: _iconSize),
                    title: Text("Technique Family: ${widget.dbItem['family']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  if (widget.dbItem['satria_muda'] != "")
                    ListTile(
                      leading: Icon(Icons.calendar_view_day, color: Colors.white, size: _iconSize),
                      title: Text("Satria Muda: ${widget.dbItem['satria_muda']} Belt - Stripe ${widget.dbItem['sm_stripe']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ListTile(
                    leading: Icon(Icons.table_rows, color: Colors.white, size: _iconSize),
                    title: Text("Jawara Muda: ${widget.dbItem['jawara_muda']} Belt - Stripe ${widget.dbItem['jm_stripe']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  Divider(color: Colors.white),
                  Text("More Information", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25)),
                  SizedBox(height: 10),
                  Text(widget.dbItem['desc'], style: TextStyle(color: Colors.white, fontSize: 16))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
