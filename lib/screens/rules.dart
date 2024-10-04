import 'package:flutter/material.dart';

class Rules extends StatelessWidget {
  const Rules({Key? key}) : super(key: key);

  final int flex1 = 2;
  final int flex2 = 5;
  final int flex1a = 1;
  final int flex2a = 5;
  final double spaceBetween = 12;
  final Color color1 = Colors.teal;
  final Color color2 = Colors.blue;
  final Color color3 = Colors.teal;
  final double _rightFontSize = 17;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules of the Class'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
              /*  Text(
                  "Rules",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: color2),
                ),
                SizedBox(
                  height: 10,
                ), */
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: flex1,
                      child: Text("Respect your instructor", style: TextStyle(
                          fontSize: _rightFontSize,
                          fontWeight: FontWeight.bold,
                          color: color2
                      ),),
                    ),
                    Expanded(
                      flex: flex2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '∙ Raise your hand in class. \n∙ Address your instructor and senior students as "Ka" (a Indonesian term of respect). \n∙ "Hormat" is a respectful way of greeting your instructors and other students.',
                          style: TextStyle(
                              fontSize: 16.0,
                          ),
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
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: flex1,
                      child: Text("Respect the class", style: TextStyle(
                          fontSize: _rightFontSize,
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
                          ),
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
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: flex1,
                      child: Text("Respect other students", style: TextStyle(
                          fontSize: _rightFontSize,
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
                          ),
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
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: flex1,
                      child: Text("Respect your uniform", style: TextStyle(
                          fontSize: _rightFontSize,
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
                          ),
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
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: flex1,
                      child: Text("Respect the art of Silat", style: TextStyle(
                          fontSize: _rightFontSize,
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
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: spaceBetween,
                ),

                SizedBox(
                  height: 30,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
