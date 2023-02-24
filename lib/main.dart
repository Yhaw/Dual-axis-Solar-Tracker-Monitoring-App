import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART SOLAR TRACKING MONITORING SYSTEM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 18.0),
        ),
      ),
      home: SolarTracker(),
    );
  }
}

class SolarTracker extends StatefulWidget {
  @override
  _SolarTrackerState createState() => _SolarTrackerState();
}

class _SolarTrackerState extends State<SolarTracker> {
  String _voltage = 'N/A';
  String _azimuth = 'N/A';
  String _elevation = 'N/A';
  String _windspeed = 'N/A';
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) => _loadData());
  }

  Future<void> _loadData() async {
    final url =
        'https://api.thingspeak.com/channels/1947245/feeds/last.json?api_key=F3TOBK1IEM2221CM';

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _voltage = data['field1'];
        _azimuth = data['field3'];
        _windspeed = data['field5'];
        _elevation = data['field4'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle the error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solar Tracker'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.battery_full_outlined,
                    size: 72.0,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Voltage',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '$_voltage V',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 32.0),
                  Icon(
                    Icons.navigation_outlined,
                    size: 72.0,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Azimuth',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '$_azimuth°',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 32.0),
                  Icon(
                    Icons.vertical_align_top_outlined,
                    size: 72.0,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Elevation',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '$_elevation°',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 32.0),
                  Icon(
                    Icons.air_outlined,
                    size: 72.0,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Wind Speed',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '$_windspeed m/s',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
      ),
    );
  }
}
