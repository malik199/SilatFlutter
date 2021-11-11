import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../models/pull_color_model.dart';
import '../models/striped_belts.dart';
import 'video_player.dart';

class TechniquesList extends StatefulWidget {
  final String color;
  final String curriculum;
  const TechniquesList(
      {Key? key, required this.curriculum, required this.color})
      : super(key: key);

  @override
  _TechniquesListState createState() => _TechniquesListState();
}

class _TechniquesListState extends State<TechniquesList> {
  DatabaseReference reference =
  FirebaseDatabase.instance.reference().child('techniques');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("this is my curriculum ${widget.curriculum}");
    print("this is my color ${widget.color}");
  }

  final vimeoKey = "a7dba65b5ca93ee1c513b8926987343c";
  //var imagepic;
  Future fetchAlbum(videoId) async {
    final response = await http.get(
      Uri.parse('https://api.vimeo.com/videos/$videoId'),
      // Send authorization headers to the backend.
      headers: {
        'Accept': 'application/vnd.vimeo.*+json;version=3.4',
        'Authorization': 'Bearer $vimeoKey',
      },
    );
    final responseJson = jsonDecode(response.body);

    //print(responseJson?["pictures"]["sizes"][0]["link"]);
    return responseJson?["pictures"]["sizes"][2]["link"];
    //return Album.fromJson(responseJson);
  }

  Widget _buildTechniqueItem({Map? dbItem, myIndex}) {
    final double _beltHeight = 35;
    final double _borderRadius = 4;
    //final double _innerPadding = 15;
    double _stripeBorderWhite = 0;

    int stripe;

    if (widget.curriculum == 'jawara_muda') {
      stripe = dbItem?["jm_showstripe"] == "" ? 0 : dbItem?["jm_showstripe"];
      _stripeBorderWhite = 0;
    } else {
      stripe = dbItem?["sm_showstripe"] == "" ? 0 : dbItem?["sm_showstripe"];
      _stripeBorderWhite = 10;
    }
    print('STRIPE $stripe');

    Widget showHeader() {
      if (stripe != 0 && stripe is int) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: Stack(children: [
              Container(
                height: _beltHeight,
                color: PullColor().getColor(widget.color),
              ),
              Container(
                height: _beltHeight,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                        width: _stripeBorderWhite, color: Colors.white),
                  ),
                ),
              ),
              StripedBelts().getStripes(stripe),
            ]),
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showHeader(),
        Card(
          child: ListTile(
            leading: FutureBuilder(
                future: fetchAlbum(dbItem?['vidID']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return Image.network(dbItem?['img']);
                    } else {
                      return Image.network(snapshot.data.toString());
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            title: Text(dbItem?['technique']),
            subtitle: Text(dbItem?['desc']),
            trailing: Icon(Icons.play_circle_outline),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayer(
                      title: dbItem?['technique'], videoId: dbItem?['vidID']),
                ),
              )
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Techniques'),
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance
              .reference()
              .child('techniques')
              .orderByChild(widget.curriculum)
              .equalTo(widget.color),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map dbItemValue = snapshot.value;
            dbItemValue['key'] = snapshot.key;
            return _buildTechniqueItem(dbItem: dbItemValue, myIndex: index);
          },
        ),
      ),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}