import 'package:flutter/material.dart';

class RulesCreed extends StatelessWidget {
  const RulesCreed({Key? key}) : super(key: key);

  final int flex1 = 2;
  final int flex2 = 5;
  final double spaceBetween = 6;
  final Color color1 = Colors.teal;
  final Color color2 = Colors.redAccent;
  final Color color3 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "The Creed",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
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
                      fontSize: 20.0,
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
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
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Text(
              "Rules",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: color2),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To serve God, honor my country, and preserve truth and justice.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To obey the principles of martial arts.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To respect and honor my instructors, the school and to discipline myself.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To be able to improve my performance.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "With faith and morality I will be strong, without faith and morality I will be weak.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: spaceBetween,
            ),
            Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Ikrar dan Janji Anggota",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: color3),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: flex1,
                  child: Text("Number 1: ", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To serve God, honor my country, and preserve truth and justice.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To obey the principles of martial arts.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To respect and honor my instructors, the school and to discipline myself.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "To be able to improve my performance.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "With faith and morality I will be strong, without faith and morality I will be weak.",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: spaceBetween,
            ),
            Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            )
          ],
        ),
      ),
    );
  }
}
