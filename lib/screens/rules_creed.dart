import 'package:flutter/material.dart';

class RulesCreed extends StatelessWidget {
  const RulesCreed({Key? key}) : super(key: key);

  final int flex1 = 2;
  final int flex2 = 5;
  final int flex1a = 1;
  final int flex2a = 5;
  final double spaceBetween = 12;
  final Color color1 = Colors.teal;
  final Color color2 = Colors.blue;
  final Color color3 = Colors.teal;

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
                  child: Text("Respect your instructor", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '∙ Raise your hand in class. \n∙ Address your instructor and senior students as "Ka" (a Indonesian term of respect). \n∙ "Hormat" is a respectful way of greeting your instructors and other students.',
                      style: TextStyle(
                          fontSize: 16.0,
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
                  child: Text("Respect the class", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '∙ Notify your instructor if you are late or absent. \n∙ Ask permission to enter or leave the class. \n∙ Keep the training area clean.',
                      style: TextStyle(
                          fontSize: 16.0,
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
                  child: Text("Respect other students", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '∙ Be polite and considerate with your fellow students. \n∙ Control your temper. \n∙ Be accommodating and amicable.',
                      style: TextStyle(
                          fontSize: 16.0,
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
                  child: Text("Respect your uniform", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '∙ Come to class with a clean uniform. \n∙ Remove your belt when eating, drinking or outside of class. \n∙ Treat your uniform, belt and sparring gear with respect.',
                      style: TextStyle(
                          fontSize: 16.0,
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
                  child: Text("Respect the art of Silat", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color2),),
                ),
                Expanded(
                  flex: flex2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '∙ Use silat only in self-defense. \n∙ Never instigate or provoke someone to fight. \n∙ Practice your techniques regularly at home.',
                      style: TextStyle(
                          fontSize: 16.0,
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
                  flex: flex1a,
                  child: Text("Satu:", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2a,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Mengabdi kepada Allah, bangsa dan negara, serta membela keadilan dan kebenaran.",
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
                  flex: flex1a,
                  child: Text("Dua", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2a,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Mentaati azas-azas bela diri.",
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
                  flex: flex1a,
                  child: Text("Tiga", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2a,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Patuh dan taat kepada pimpinan serta disiplin pribadi.",
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
                  flex: flex1a,
                  child: Text("Empat", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2a,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Sanggup meningkatkan prestasi.",
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
                  flex: flex1a,
                  child: Text("Lima", style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color3),),
                ),
                Expanded(
                  flex: flex2a,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "Dengan iman dan akhlak saya menjadi kuat. \nTanpa iman dan akhlak saya menjadi lemah.",
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
