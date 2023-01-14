import 'dart:ffi';

import 'package:flutter/material.dart';

class DailyWatherCard extends StatelessWidget {
  const DailyWatherCard(
      {Key? key,
      required this.icon,
      required this.tempruter,
      required this.date})
      : super(key: key);

  final String icon;
  final double tempruter;
  final String date;

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];
    String weekDay;
    weekDay = weekDays[DateTime.parse(date).weekday - 1];

    return Card(
      color: Colors.transparent,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('http://openweathermap.org/img/wn/$icon@2x.png'),
            Text(
              '$tempruter° C',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(weekDay)
          ],
        ),
      ),
    );
  }
}
