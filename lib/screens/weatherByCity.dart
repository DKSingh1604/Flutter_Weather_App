import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_x/bloc/weather_bloc_bloc.dart';

class WeatherByCity extends StatefulWidget {
  const WeatherByCity({super.key});

  @override
  State<WeatherByCity> createState() => _WeatherByCityState();
}

class _WeatherByCityState extends State<WeatherByCity> {
  final TextEditingController _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather By City'),
      ),
      body: BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
        builder: (context, state) {
          if (state is WeatherBlocLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WeatherBlocSuccess) {
            return Column(
              children: [
                Text(
                  "${state.weather.areaName}, ${state.weather.country}",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  "${state.weather.temperature!.celsius!.toStringAsFixed(1)}°C",
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                Text(
                  "${state.weather.weatherMain!.toUpperCase()}",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ],
            );
          } else if (state is WeatherBlocFailure) {
            return Center(
              child:
                  Text("City not found!", style: TextStyle(color: Colors.red)),
            );
          }
          return Container();
        },
      ),
    );
  }
}
