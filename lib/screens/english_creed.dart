import 'package:flutter/material.dart';

class CreedEnglish extends StatelessWidget {
  const CreedEnglish({Key? key}) : super(key: key);

  final int flex1 = 2;
  final int flex2 = 5;
  final int flex1a = 1;
  final int flex2a = 5;
  final double spaceBetween = 5;
  final Color color1 = Colors.teal;
  final Color color2 = Colors.blue;
  final Color color3 = Colors.teal;
  final double _rightFontSize = 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Creed'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "The Creed",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text("Number 1: ", style: TextStyle(
                        fontSize: _rightFontSize,
                        fontWeight: FontWeight.bold,
                        color: color1),),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "To serve God, honor my country, and preserve truth and justice.",
                        style: TextStyle(
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text("Number 2: ", style: TextStyle(
                        fontSize: _rightFontSize,
                        fontWeight: FontWeight.bold,
                        color: color1),),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "To obey the principles of martial arts.",
                        style: TextStyle(
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text("Number 3: ", style: TextStyle(
                        fontSize: _rightFontSize,
                        fontWeight: FontWeight.bold,
                        color: color1),),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "To respect and honor my instructors, the school and to discipline myself.",
                        style: TextStyle(
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text("Number 4: ", style: TextStyle(
                        fontSize: _rightFontSize,
                        fontWeight: FontWeight.bold,
                        color: color1),),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "To be able to improve my performance.",
                        style: TextStyle(
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: spaceBetween,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: flex1,
                    child: Text("Number 5: ", style: TextStyle(
                        fontSize: _rightFontSize,
                        fontWeight: FontWeight.bold,
                        color: color1),),
                  ),
                  Expanded(
                    flex: flex2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "With faith and morality I will be strong, without faith and morality I will be weak.",
                        style: TextStyle(
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
