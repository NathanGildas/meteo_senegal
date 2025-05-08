import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forecast.dart';
import '../models/weather.dart';

class WeatherService {
  static const String _apiKey = '882918bcd63cd6fee42aceeaf962e956';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("Ville inconnue");
    } else {
      throw Exception("Erreur lors de la récupération des données météo");
    }
  }

  Future<List<Forecast>> fetchForecast(String city) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body)['list'];
      return list.map((e) => Forecast.fromJson(e)).toList();
    } else {
      throw Exception('Erreur de chargement des prévisions');
    }
  }
}



