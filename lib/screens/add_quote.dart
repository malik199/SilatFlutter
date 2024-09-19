import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AddQuotePage extends StatefulWidget {
  @override
  _AddQuotePageState createState() => _AddQuotePageState();
}

class _AddQuotePageState extends State<AddQuotePage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();
  final TextEditingController _quoteTextController = TextEditingController();

  final _focusQuote = FocusNode();

  bool _isProcessing = false;

  late DateTime _selectedDate;
  String eventDate = "";

  final String _initDate = DateTime.now().toString();
  late DateTime _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _selectedDeadline = DateTime.parse(_initDate);
    _selectedDate = DateTime.parse(_initDate);
  }

  String eventDeadline = "";

  final snackBarRed = SnackBar(
    content: Text('A problem occurred.'),
    backgroundColor: Colors.red,
  );
  final snackBarGreen = SnackBar(
    content: Text('Success! You added an quote!'),
    backgroundColor: Colors.green,
  );

  void submitQuote() {
    setState(() {
      _isProcessing = true;
    });
    final nextQuote = <String, dynamic>{
      'quote': _quoteTextController.text,
      'date': DateTime.now().toString(),
    };
    if (_registerFormKey.currentState!
        .validate()) {
      _database
          .child('quotes')
          .push()
          .set(nextQuote)
          .then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarGreen);

        //Clear out data
        setState(() {
          _quoteTextController.text = "";
        });

      }).catchError((error) {
        print(error);
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarRed);
      });
    } else {
      setState(() {
        _isProcessing = false;
      });
    }
    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusQuote.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Quote'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: _registerFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _quoteTextController,
                      validator: (value) => Validator.validateQuote(
                        quote: value,
                      ),
                      maxLines: null, // Allows the input to have multiple lines
                      keyboardType: TextInputType
                          .multiline, // Set keyboard type to multiline
                      decoration: InputDecoration(
                        hintText: 'Enter your Quote here',
                        border:
                            OutlineInputBorder(), // Adds a border around the TextField
                        labelText: 'Quote of the Week',
                      ),
                    ),
                    SizedBox(height: 30),
                    _isProcessing
                        ? CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text and icon color
                                      ),
                                      onPressed: submitQuote,
                                      child: Text("ADD QUOTE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))))
                            ],
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Validator {
  static String? validateQuote({required String? quote}) {
    if (quote == null) {
      return null;
    }

    if (quote.isEmpty) {
      return 'Quote can\'t be empty';
    }

    return null;
  }
}
