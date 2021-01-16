import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({@required this.locationweatherdata});

  final locationweatherdata;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherdata = WeatherModel();
  double tempe;
  int temperature;
  String cityName;
  String weatherIcon;
  String message;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationweatherdata);
  }

  void updateUI(dynamic decodedData) {
    if (decodedData == null) {
      setState(() {
        Alert(
          context: context,
          title: 'Error!',
          desc: 'Something goes wrong please try after some time!',
        ).show();
      });
    }
    temperature = decodedData['main']['temp'];
    // temperature = tempe.toInt();
    var condition = decodedData['weather'][0]['id'];
    cityName = decodedData['name'];
    weatherIcon = weatherdata.getWeatherIcon(condition);
    message = weatherdata.getMessage(temperature);
    print(cityName);
  }

  void updateCityUI(dynamic decodedData) {
    if (decodedData == null) {
      setState(() {
        Alert(
          context: context,
          title: 'Error!',
          desc: 'Something goes wrong please try after some time!',
        ).show();
      });
    }
    tempe = decodedData['main']['temp'];
    temperature = tempe.toInt();
    var condition = decodedData['weather'][0]['id'];
    cityName = decodedData['name'];
    weatherIcon = weatherdata.getWeatherIcon(condition);
    message = weatherdata.getMessage(temperature);
    print(cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weatherdata.getLocationData();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      if (typedName != null) {
                        var weatherData =
                            await weatherdata.getCityweatherData(typedName);

                        updateCityUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 65.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$message in $cityName!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
