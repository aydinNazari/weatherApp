import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hava_durumu1/widget/loading_widget.dart';
import 'package:hava_durumu1/widget/wather_daily_card.dart';
import 'search_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = 'Ankara';
  double? tempureture;
  final String key = '87d43b7c87a34b6bb94d2063a21f5da5';
  String code = 'c';
  var locationData;
  Position? devicePosition;
  String? icon;
  var forcastData;
  var forcastDataParsed;

  List<String> icons = [
    "02n",
    "02n",
    "02n",
    "02n",
    "02n",
  ];
  List<double> temputeres = [
    20.15,
    20.18,
    20.15,
    19.00,
    18.25,
  ];
  List<String> dates = [
    "Sali",
    "Çarşamba",
    "Perşembe",
    "Cuma",
    "Cumartesi",
    "Pazar",
  ];

  Future<void> getLocationDataFromAPI() async {
    // print('********************************');
    locationData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$key&units=metric'));
    final locatinDataParsed = jsonDecode(locationData.body);
    //print('$locatinDataParsed');

    setState(() {
      tempureture = locatinDataParsed['main']['temp'];
      location = locatinDataParsed['name'];
      //code = locatinDataParsed['weather'].first['main'];    buda olur aşşağıda yazdığım da olur
      code = locatinDataParsed['weather'][0]['main'];
      // print('******');
      //print('$code');
      //print('şehir : $location - temputer: $tempureture');
      //print('//////////////////////////////////////////');
      icon = locatinDataParsed['weather'][0]['icon'];
    });
  }

  Future<void> getLocationDataFromAPIByLatLon() async {
    if (devicePosition != null) {
      // print('********************************');
      locationData = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric'));
      final locatinDataParsed = jsonDecode(locationData.body);
      // print('$locatinDataParsed');

      setState(() {
        tempureture = locatinDataParsed['main']['temp'];
        location = locatinDataParsed['name'];
        //code = locatinDataParsed['weather'].first['main'];    buda olur aşşağıda yazdığım da olur
        code = locatinDataParsed['weather'][0]['main'];
        // print('******');
        //print('$code');
        //print('şehir : $location - temputer: $tempureture');
        //print('//////////////////////////////////////////');
        icon = locatinDataParsed['weather'][0]['icon'];
      });
    }
  }

  Future<void> getDeviceLocation() async {
    try {
      devicePosition = await _determinePosition();
    } catch (error) {
      print('hata : $error');
    }
    //print('$devicePosition');
  }

  Future<void> getDailyForecastbyLatLon() async {
    forcastData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${devicePosition!.latitude}&lon=${devicePosition!.longitude}&appid=$key&units=metric'));
    forcastDataParsed = jsonDecode(forcastData.body);
    temputeres.clear();
    icons.clear();
    dates.clear();
    setState(() {
      /* for (int i = 7; i < 40; i++) {
        temputeres.add(forcastDataParsed['list'][i]['main']['temp']);
        icons.add(forcastDataParsed['list'][7]['weather'][0]['icon']);
        dates.add(forcastDataParsed['list'][7]['dt_txt']);
      }*/
      for (int i = 7; i < 40; i = i + 8) {
        temputeres.add(forcastDataParsed['list'][i]['main']['temp']);
        icons.add(forcastDataParsed['list'][i]['weather'][0]['icon']);
        dates.add(forcastDataParsed['list'][i]['dt_txt']);
      }
    });
  }

  Future<void> getDailyForcestbyLocation() async {
    forcastData = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$key&units=metric'));
    forcastDataParsed = jsonDecode(forcastData.body);
    temputeres.clear();
    icons.clear();
    dates.clear();
    setState(() {
      for (int i = 7; i < 40; i = i + 8) {
        temputeres.add(forcastDataParsed['list'][i]['main']['temp']);
        icons.add(forcastDataParsed['list'][i]['weather'][0]['icon']);
        dates.add(forcastDataParsed['list'][i]['dt_txt']);
      }
    });
  }

  void getInitialData() async {
    await getDeviceLocation();
    await getLocationDataFromAPIByLatLon(); //curent wather data
    await getDailyForecastbyLatLon(); //forcest by 5days
  }

  @override
  void initState() {
    getInitialData();
    //getLocationDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/$code.jpg'), fit: BoxFit.cover),
      ),
      child: (tempureture == null || devicePosition == null)
          ? const LoadingWidget()
          : SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          'http://openweathermap.org/img/wn/$icon@2x.png'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            location,
                            style: const TextStyle(
                                fontSize: 45,
                                shadows: <Shadow>[
                                  Shadow(
                                      color: Colors.black12,
                                      blurRadius: 3,
                                      offset: Offset(4, 3))
                                ],
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                              onPressed: () async {
                                final selectedCity = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchPage()));
                                // print(upperCity);

                                //var upperCity = selectedCity.capitalize();
                                location = selectedCity;
                                getLocationDataFromAPI();
                                getDailyForcestbyLocation();
                              },
                              icon: const Icon(
                                Icons.search,
                                size: 35,
                              ))
                        ],
                      ),
                      Text(
                        '$tempureture° C',
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.w500,
                          shadows: <Shadow>[
                            Shadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(3, 3))
                          ],
                        ),
                      ),
                      BuildWetherCard(context)
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  SizedBox BuildWetherCard(BuildContext context) {
    List<DailyWatherCard> cards = [];
    for (int i = 0; i < 5; i++) {
      cards.add(DailyWatherCard(
        icon: icons[i],
        tempruter: temputeres[i],
        date: dates[i],
      ));
    }
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }

  //konumla ilgili kodlar
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

//bu fonksiyon kelimenin ilk harfini büyütmeye yarıyor
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
