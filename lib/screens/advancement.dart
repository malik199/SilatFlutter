import 'package:flutter/material.dart';
import 'package:silat_flutter/models/belts_complex.dart';

class Advancement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _smallFont = 13;
    double _mediumFont = 15;
    double _largeFont = 22;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Belt Advancement', style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[300],
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                  "Note: An advancement can only be obtained if approved by a black/red belt. Stripes beyond black belt must be awarded by someone who is two levels more advanced.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: _smallFont,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              Divider(),
              Text("Satria Muda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _largeFont)),
              Text("Beginner Curriculum",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black38)),
              SizedBox(height: 20),
              Text(
                  "Students must memorize the Creed before wearing the uniform.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "satria_muda", color: "white", stripes: 5),
              BeltsComplex(
                  curriculum: "satria_muda", color: "yellow", stripes: 5),
              BeltsComplex(
                  curriculum: "satria_muda", color: "green", stripes: 5),
              Text("Tournament required.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "satria_muda", color: "blue", stripes: 5),
              BeltsComplex(
                  curriculum: "satria_muda", color: "purple", stripes: 5),
              Text("Tournament required.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "satria_muda", color: "brown", stripes: 5),
              Text("Jawara Muda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _largeFont)),
              Text("Advanced Curriculum",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _mediumFont,
                      color: Colors.black38)),
              BeltsComplex(
                  curriculum: "jawara_muda", color: "white", stripes: 5),
              BeltsComplex(
                  curriculum: "jawara_muda", color: "yellow", stripes: 5),
              Text("Tournament required.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda", color: "green", stripes: 5),
              Text(
                  "Must memorize the creed in Indonesian language.\nTournament required.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda", color: "blue", stripes: 5),
              Text("Tournament required.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda", color: "purple", stripes: 3),
              Text(
                  "Requires a non-sparring test, or participation in 10 tournaments",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda",
                  color: "purple",
                  jawaraStripe: true,
                  stripes: 3),
              BeltsComplex(curriculum: "jawara_muda", color: "brown"),
              Text(
                  "Requires a non-sparring test, or participation in 12 tournaments",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda",
                  color: "brown",
                  jawaraStripe: true,
                  stripes: 3),
              Text("Instructor",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _largeFont)),
              Text("No more outdoor Belt Tests needed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black38)),
              BeltsComplex(
                  curriculum: "jawara_muda",
                  color: "black",
                  stripes: 1,
                  hasYellowStripe: true),
              Text("2 years of active teaching & practice",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda",
                  color: "black",
                  stripes: 6,
                  hasYellowStripe: true),
              Text("4 years of active teaching & practice",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda",
                  color: "black",
                  stripes: 7,
                  hasYellowStripe: true),
              Text(
                  "6 years of active teaching & practice.\nTournament required.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda",
                  color: "black",
                  stripes: 8,
                  hasYellowStripe: true),
              Text(
                  "8 years of active teaching & practice.\nTournament required.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(
                  curriculum: "jawara_muda",
                  color: "black",
                  stripes: 9,
                  hasYellowStripe: true),
              Text(
                  "10 years of active teaching & practice.\nTrain in South-East Asia for 1 month",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(curriculum: "jawara_muda", color: "red", stripes: 6),
              Text(
                  "15 years of active teaching & practice.\nTrain in South-East Asia for 2 months",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(curriculum: "jawara_muda", color: "red", stripes: 7),
              Text(
                  "20 years of active teaching & practice.\nTrain in South-East Asia for 3 months",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(curriculum: "jawara_muda", color: "red", stripes: 8),
              Text(
                  "+25 years of active teaching & practice.\nTrain in South-East Asia for +4 months",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: _smallFont, color: Colors.black)),
              BeltsComplex(curriculum: "jawara_muda", color: "red", stripes: 9),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
