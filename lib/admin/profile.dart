import 'package:flutter/material.dart';
import 'package:silat_flutter/widgets/textfield_widget.dart';
import 'package:fluttermoji/fluttermoji.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double paddingBetween = 24;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person_outline),
            SizedBox(width: 20),
            const Text('My Profile'),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: paddingBetween),
          TextFieldWidget(
            label: 'Full Name',
            text: "Malik",
            onChanged: (name) {},
          ),
          SizedBox(height: paddingBetween),
          TextFieldWidget(
            label: 'Email',
            text: "Malik100@sada.com",
            onChanged: (email) {},
          ),
          SizedBox(height: paddingBetween),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                  primary: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              icon: Icon(Icons.save),
              label: Text("Update Profile"),
              onPressed: () => {}),
          SizedBox(height: paddingBetween),
          TextFieldWidget(
            label: 'About',
            text: "Now you know about me",
            maxLines: 3,
            onChanged: (about) {},
          ),
          SizedBox(height: paddingBetween),
          FluttermojiCircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 100,
          ),
          SizedBox(height: paddingBetween),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                primary: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle:
                TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            icon: Icon(Icons.edit),
            label: Text("Change Avatar"),
            onPressed: () => Navigator.push(context,
                new MaterialPageRoute(builder: (context) => NewPage())),
          ),
        ],
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    var isWeb = platform != TargetPlatform.android ||
        platform != TargetPlatform.iOS ||
        platform != TargetPlatform.fuchsia;

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
