import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*var platform = Theme.of(context).platform;
    var isWeb = platform != TargetPlatform.android ||
        platform != TargetPlatform.iOS ||
        platform != TargetPlatform.fuchsia;*/

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: FluttermojiCircleAvatar(
              radius: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
            child: FluttermojiCustomizer(
              //scaffoldHeight: 400,
              showSaveWidget: true,
              scaffoldWidth: 600,
            ),
          ),
        ],
      ),
    );
  }
}