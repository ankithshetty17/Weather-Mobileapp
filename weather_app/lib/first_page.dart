import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = '5c08437342aab42382dffe97ff8f67d7'; // Replace with your OpenWeatherMap API key
  String city = ''; // Replace with the desired city name
  bool isAppBarVisible = true; // Set to true by default

  Future getWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null; // Return null in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isAppBarVisible = !isAppBarVisible;
        });
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: isAppBarVisible
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(65.0),
                  child: AppBar(
                    title: isAppBarVisible
                        ? Text(
                            'Weather App',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          )
                        : SizedBox.shrink(),
                    backgroundColor:
                        Color.fromARGB(255, 241, 39, 39).withOpacity(0.1),
                    centerTitle: true,
                    elevation: 0,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                )
              : PreferredSize(
                  child: Container(),
                  preferredSize: Size(0.0, 0.0),
                ),
          body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/123.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          city = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'ENTER CITY NAME',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.0),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 245, 186, 11), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: getWeather(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Image.asset(
                            'assets/images/rocket.png',
                            height: 200,
                            width: 200,
                           
                          ),
                        );
                      } else {
                        var weatherData = snapshot.data;
                        if (weatherData == null) {
                          return Center(
                             child: Opacity(
                          opacity: 0.5,
                            child:Image.asset(
                              'assets/images/rocket.png', 
                              height: 200,
                              width: 200,
                            
                            ),
                             ),
                          );
                        }

                        var cityName = weatherData?['name'];
                        var temperature = (weatherData?['main']['temp'] - 273.15)
                            .toStringAsFixed(2);

                        return Center(
                          child: Container(
                            width: 200, // Set the width of the container
                            height: 150, // Set the height of the container
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 252, 228, 228).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$cityName',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(225, 36, 36, 35),
                                  ),
                                ),
                                Text(
                                  '$temperature°C',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(225, 36, 36, 35),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
