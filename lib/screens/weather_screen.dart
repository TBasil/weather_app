import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/login_screen.dart';
import 'package:weather_app/widgets/button.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  String _cityName = '';
  Weather? _weather;
  String _errorMessage = '';

  void _getWeather() async {
    try {
      var weatherData = await _weatherService.fetchWeather(_cityName);
      setState(() {
        _weather = weatherData;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weather data';
        _weather = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          decoration: const InputDecoration(labelText: 'Enter City Name'),
                          onChanged: (value) {
                            _cityName = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        Button(
                          label: 'Get Weather',
                          style: const TextStyle(fontSize: 16),
                          onPressed: _getWeather,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_weather != null)
                  Column(
                    children: [
                      Text('Temperature: ${_weather!.temperature}°C', style: const TextStyle(fontSize: 24)),
                      Text('Description: ${_weather!.description}', style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                if (_errorMessage.isNotEmpty)
                  Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                Button(
                  label: 'Sign out',
                  style: const TextStyle(fontSize: 16),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
