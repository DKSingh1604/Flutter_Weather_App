// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_x/bloc/weather_bloc_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool _isToastShown = false;

  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset(
          "assets/thunderstorm.png",
          height: 250,
        );
      case >= 300 && < 400:
        return Image.asset(
          "assets/drizzle.png",
          height: 250,
        );
      case >= 500 && < 600:
        return Image.asset(
          "assets/rain.png",
          height: 250,
        );
      case >= 600 && < 700:
        return Image.asset(
          "assets/snow.png",
          height: 250,
        );
      case >= 700 && < 800:
        return Image.asset(
          "assets/fog.png",
          height: 250,
        );
      case == 800:
        return Image.asset(
          "assets/clear-sky.png",
          height: 250,
        );
      case > 800 && <= 804:
        return Image.asset(
          "assets/cloud.png",
          height: 250,
        );
      default:
        return Image.asset(
          "assets/clear-sky.png",
          height: 250,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: TextField(
          controller: _cityController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            label: Text("City Name"),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                if (_cityController.text.isNotEmpty) {
                  setState(() {
                    _isToastShown = false;
                  });
                  BlocProvider.of<WeatherBlocBloc>(context).add(
                    FetchWeatherByCity(_cityController.text),
                  );

                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 2 * kToolbarHeight, 40, 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(8.5, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-8.5, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, -1.2),
                  child: Container(
                    height: 300,
                    width: 600,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      color: Color(0xFFFFAB40),
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                  ),
                ),
                BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                  builder: (context, state) {
                    //LOADING
                    if (state is WeatherBlocLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      //SUCCESS
                    } else if (state is WeatherBlocSuccess) {
                      if (!_isToastShown) {
                        _isToastShown = true;
                        Fluttertoast.showToast(
                          msg: "Weather data fetched successfully!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      }

                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                // L O C A T I O N
                                Icon(
                                  Icons.location_pin,
                                  size: 26,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "${state.weather.areaName}, ${state.weather.country}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            //G R E E T I N G
                            Text(
                              "Good Morning",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              //I M A G E
                              padding: const EdgeInsets.all(17.0),
                              child: getWeatherIcon(
                                  state.weather.weatherConditionCode!),
                            ),
                            Center(
                              // T E M P E R A T U R E
                              child: Text(
                                "${state.weather.temperature!.celsius!.toStringAsFixed(2)}°C",
                                style: TextStyle(
                                    fontSize: 35, color: Colors.white),
                              ),
                            ),
                            Center(
                              // W E A T H E R
                              child: Text(
                                "${state.weather.weatherMain!.toUpperCase()}",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ),
                            Center(
                              // D A T E
                              child: Text(
                                DateFormat("DD/MM/yyyy EEEE HH:mm")
                                    .format(state.weather.date!),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.sunny,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //S U N R I S E
                                          "Sunrise",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "${DateFormat("HH:mm").format(state.weather.sunrise!)}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.dark_mode,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //S U N S E T
                                          "Sunset",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "${DateFormat("HH:mm").format(state.weather.sunset!)}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(
                              color: Colors.white,
                              thickness: 0.4,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.hot_tub,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //T E M P  M A X
                                          "Temp Max",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "${state.weather.tempMax!.celsius!.toStringAsFixed(1)}°C",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.ac_unit,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          //T E M P   M I N
                                          "Temp Min",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "${state.weather.tempMin!.celsius!.toStringAsFixed(1)}°C",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else if (state is WeatherBlocFailure) {
                      return Center(
                        child: Text(
                          "City not found!",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
