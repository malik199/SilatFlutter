import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

//a7dba65b5ca93ee1c513b8926987343c Vimeo Private Key

class TechniquesList extends StatefulWidget {
  const TechniquesList({Key? key}) : super(key: key);

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
    final double _stripeWidth = 10;
    final double _stripeSpacing = 10;

    Widget showHeader() {
      if (dbItem?["jm_showstripe"] != "") {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: _beltHeight,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: _stripeSpacing),
                        Container(
                          width: _stripeWidth,
                          color: Colors.black,
                        ),
                        SizedBox(width: _stripeSpacing),
                        Container(
                          width: _stripeWidth,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: _stripeWidth,
                          color: Colors.black,
                        ),
                        SizedBox(width: _stripeSpacing),
                        Container(
                          width: _stripeWidth,
                          color: Colors.black,
                        ),
                        SizedBox(width: _stripeSpacing),
                      ],
                    ),
                  ),
                ],
              )),
        );
      } else {
        return SizedBox.shrink();
      }
    }
    Future thumbURL = fetchAlbum(dbItem?['vidID']);
    //print(fetchAlbum(dbItem?['vidID']));
    //String thumbURL = "https://firebasestorage.googleapis.com/v0/b/silat-moves-app.appspot.com/o/kananKiri.png?alt=media&token=6a710592-a444-4db5-863e-afcf1be3a434";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showHeader(),
        Card(
          child: ListTile(
            //leading: Image.network(thumbURL),
            leading: FutureBuilder(
            future: fetchAlbum(dbItem?['vidID']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Image.network(snapshot.data.toString());
                } else {
                  return CircularProgressIndicator();
                }
              }
    ),
            title: Text(dbItem?['technique']),
            subtitle: Text(dbItem?['desc']),
            trailing: Icon(Icons.play_circle_outline),
            onTap: () => {print("Technique Tapped")},
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
              .orderByChild('jawara_muda')
              .equalTo('yellow'),
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