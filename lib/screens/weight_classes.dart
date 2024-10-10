import 'package:flutter/material.dart';

class WeightClasses extends StatefulWidget {
  @override
  _WeightClassesState createState() => _WeightClassesState();
}

class _WeightClassesState extends State<WeightClasses> {
  final _formKey = GlobalKey<FormState>();
  String? _ageGroup;
  String? _gender;
  double? _weight;
  bool _isKilos = false; // By default, assume the weight is in kilos
  String? _classification;

  final Map<String, List<Map<String, dynamic>>> _weightClasses = {
    "Pre-Teen (under 11)": [
      {
        "over": 18,
        "under": 26,
        "class_male": "A Mini",
        "class_female": "A Mini"
      },
      {
        "over": 26,
        "under": 28,
        "class_male": "A",
        "class_female": "A"
      },
      {
        "over": 28,
        "under": 30,
        "class_male": "B",
        "class_female": "B"
      },
      {
        "over": 30,
        "under": 32,
        "class_male": "C",
        "class_female": "C"
      },
      {
        "over": 32,
        "under": 34,
        "class_male": "D",
        "class_female": "D"
      },
      {
        "over": 34,
        "under": 36,
        "class_male": "E",
        "class_female": "E"
      },
      {
        "over": 36,
        "under": 38,
        "class_male": "F",
        "class_female": "F"
      },
      {
        "over": 38,
        "under": 40,
        "class_male": "G",
        "class_female": "G"
      },
      {
        "over": 40,
        "under": 42,
        "class_male": "H",
        "class_female": "H"
      },
      {
        "over": 42,
        "under": 44,
        "class_male": "I",
        "class_female": "I"
      },
      {
        "over": 44,
        "under": 46,
        "class_male": "J",
        "class_female": "J"
      },
      {
        "over": 46,
        "under": 48,
        "class_male": "K",
        "class_female": "K"
      },
      {
        "over": 48,
        "under": 50,
        "class_male": "L",
        "class_female": "L"
      },
      {
        "over": 50,
        "under": 52,
        "class_male": "M",
        "class_female": "M"
      },
      {
        "over": 52,
        "under": 54,
        "class_male": "N",
        "class_female": "N"
      },
      {
        "over": 54,
        "under": 56,
        "class_male": "O",
        "class_female": "O"
      },
      {
        "over": 56,
        "under": 58,
        "class_male": "P",
        "class_female": "P"
      },
      {
        "over": 58,
        "under": 60,
        "class_male": "Q",
        "class_female": "Q"
      },
      {
        "over": 60,
        "under": 62,
        "class_male": "R",
        "class_female": "R"
      },
      {
        "over": 62,
        "under": 64,
        "class_male": "S",
        "class_female": "S"
      },
      {
        "over": 64,
        "under": 68,
        "class_male": "Open",
        "class_female": "Open"
      }
    ],
    "Pre-Junior (12-13)": [
      {
        "over": 30,
        "under": 33,
        "class_male": "A",
        "class_female": "A"
      },
      {
        "over": 33,
        "under": 36,
        "class_male": "B",
        "class_female": "B"
      },
      {
        "over": 36,
        "under": 39,
        "class_male": "C",
        "class_female": "C"
      },
      {
        "over": 39,
        "under": 42,
        "class_male": "D",
        "class_female": "D"
      },
      {
        "over": 42,
        "under": 45,
        "class_male": "E",
        "class_female": "E"
      },
      {
        "over": 45,
        "under": 48,
        "class_male": "F",
        "class_female": "F"
      },
      {
        "over": 48,
        "under": 51,
        "class_male": "G",
        "class_female": "G"
      },
      {
        "over": 51,
        "under": 54,
        "class_male": "H",
        "class_female": "H"
      },
      {
        "over": 54,
        "under": 57,
        "class_male": "I",
        "class_female": "I"
      },
      {
        "over": 57,
        "under": 60,
        "class_male": "J",
        "class_female": "J"
      },
      {
        "over": 60,
        "under": 63,
        "class_male": "K",
        "class_female": "K"
      },
      {
        "over": 63,
        "under": 66,
        "class_male": "L",
        "class_female": "L"
      },
      {
        "over": 66,
        "under": 69,
        "class_male": "M",
        "class_female": "M"
      },
      {
        "over": 69,
        "under": 72,
        "class_male": "N",
        "class_female": "N"
      },
      {
        "over": 72,
        "under": 75,
        "class_male": "O",
        "class_female": "O"
      },
      {
        "over": 75,
        "under": 78,
        "class_male": "P",
        "class_female": "P"
      },
      {
        "over": 78,
        "under": 84,
        "class_male": "Open",
        "class_female": "Open"
      }
    ],
    "Junior (14-16)": [
      {
        "over": 39,
        "under": 43,
        "class_male": "A",
        "class_female": "A"
      },
      {
        "over": 43,
        "under": 47,
        "class_male": "B",
        "class_female": "B"
      },
      {
        "over": 47,
        "under": 51,
        "class_male": "C",
        "class_female": "C"
      },
      {
        "over": 51,
        "under": 55,
        "class_male": "D",
        "class_female": "D"
      },
      {
        "over": 55,
        "under": 59,
        "class_male": "E",
        "class_female": "E"
      },
      {
        "over": 59,
        "under": 63,
        "class_male": "F",
        "class_female": "F"
      },
      {
        "over": 63,
        "under": 67,
        "class_male": "G",
        "class_female": "G"
      },
      {
        "over": 67,
        "under": 71,
        "class_male": "H",
        "class_female": "H"
      },
      {
        "over": 71,
        "under": 75,
        "class_male": "I",
        "class_female": "I"
      },
      {
        "over": 75,
        "under": 79,
        "class_male": "J",
        "class_female": "J"
      },
      {
        "over": 79,
        "under": 83,
        "class_male": "K",
        "class_female": "Open 1"
      },
      {
        "over": 83,
        "under": 87,
        "class_male": "L",
        "class_female": "Open 1"
      },
      {
        "over": 87,
        "under": 92,
        "class_male": "Open 1",
        "class_female": "Open 1"
      },
      {
        "over": 92,
        "under": 100,
        "class_male": "Open 1",
        "class_female": "Open 2"
      },
      {
        "over": 100,
        "under": 300,
        "class_male": "Open 2",
        "class_female": "Open 2"
      }
    ],
    "Adult (17-45)": [
      {
        "over": 45,
        "under": 50,
        "class_male": "A",
        "class_female": "A"
      },
      {
        "over": 50,
        "under": 55,
        "class_male": "B",
        "class_female": "B"
      },
      {
        "over": 55,
        "under": 60,
        "class_male": "C",
        "class_female": "C"
      },
      {
        "over": 60,
        "under": 65,
        "class_male": "D",
        "class_female": "D"
      },
      {
        "over": 65,
        "under": 70,
        "class_male": "E",
        "class_female": "E"
      },
      {
        "over": 70,
        "under": 75,
        "class_male": "F",
        "class_female": "F"
      },
      {
        "over": 75,
        "under": 80,
        "class_male": "G",
        "class_female": "G"
      },
      {
        "over": 80,
        "under": 85,
        "class_male": "H",
        "class_female": "H"
      },
      {
        "over": 85,
        "under": 90,
        "class_male": "I",
        "class_female": "Open 1"
      },
      {
        "over": 90,
        "under": 95,
        "class_male": "J",
        "class_female": "Open 1"
      },
      {
        "over": 95,
        "under": 100,
        "class_male": "Open 1",
        "class_female": "Open 1"
      },
      {
        "over": 100,
        "under": 110,
        "class_male": "Open 1",
        "class_female": "Open 2"
      },
      {
        "over": 110,
        "under": 400,
        "class_male": "Open 2",
        "class_female": "Open 2"
      }
    ]
  };

  void _classify() {
    if (_weight == null || _ageGroup == null || _gender == null) {
      return;
    }
    double weightInKilos = _isKilos ? _weight! : _weight! * 0.453592; // Convert pounds to kilos if needed
    List<Map<String, dynamic>> classes = _weightClasses[_ageGroup]!;
    for (var weightClass in classes) {
      if (weightInKilos >= weightClass['over'] && weightInKilos < weightClass['under']) {
        setState(() {
          _classification = _gender == "male" ? weightClass['class_male'] : weightClass['class_female'];
        });
        return;
      }
    }
    setState(() {
      _classification = "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Classification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _ageGroup,
                hint: Text("Select Age Group"),
                validator: (value) => value == null || value.isEmpty ? 'Please select an age group' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    _ageGroup = newValue;
                  });
                },
                items: _weightClasses.keys.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),

              DropdownButtonFormField<String>(
                value: _gender,
                hint: Text("Select Gender"),
                validator: (value) => value == null || value.isEmpty ? 'Please select a gender' : null,
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
                items: ['male', 'female'].map((String gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
              ),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Weight',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a weight';
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return '"$value" is not a valid number';
                  }
                  return null; // means input is valid
                },
                onSaved: (value) {
                  _weight = double.tryParse(value!);
                },
              ),
              Row(
                children: <Widget>[
                  Text('Pounds'),
                  Switch(
                    value: _isKilos,
                    onChanged: (value) {
                      setState(() {
                        _isKilos = value;
                      });
                    },
                  ),
                  Text('Kilos'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _classify();
                  }
                },
                child: Text('FIND MY WEIGHT CLASS', style: TextStyle(fontFamily: 'PTSansNarrow', fontWeight: FontWeight.bold
                )),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.purple),
                ),
              ),
              SizedBox(height: 20),
              if (_classification != null)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('CLASS:', style: TextStyle(
                        fontSize: 25,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),),
                      Text(_classification.toString(),
                        style: TextStyle(
                          fontSize: 90,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
