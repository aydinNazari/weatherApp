import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCity = '';
  final String key = '87d43b7c87a34b6bb94d2063a21f5da5';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/search.jpg'), fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextField(
                    onChanged: (txt) {
                      selectedCity = txt;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text("    Ara    "),
                    onPressed: () async {
                      var respons = await http.get(Uri.parse(
                          'https://api.openweathermap.org/data/2.5/weather?q=$selectedCity&appid=$key&units=metric'));
                      final locatinDataParsed = jsonDecode(respons.body);
                      if (locatinDataParsed['cod'] != 200) {
                        // Mesaj(Colors.red, 'Location not found', 1);
                        _showMyDialog();
                      } else
                        Navigator.pop(context, selectedCity);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff555555),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Mesaj(Color color, String mesaj, int saniye) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        mesaj,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: Duration(seconds: saniye),
    ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location not found'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please select a valid location'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
