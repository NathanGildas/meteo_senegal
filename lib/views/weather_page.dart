import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatelessWidget {
  final String city;
  final WeatherService _service = WeatherService();

  WeatherPage({required this.city});

  // Fonction pour obtenir le nom du jour depuis un entier (1 = Lundi)
  String _getDayName(int weekday) {
    const days = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];
    return days[(weekday - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Météo à $city")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Météo actuelle
            FutureBuilder<Weather>(
              future: _service.fetchWeather(city),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Erreur : ${snapshot.error.toString()}"),
                  );
                } else if (snapshot.hasData) {
                  final weather = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(weather.cityName, style: TextStyle(fontSize: 24)),
                            Image.network("https://openweathermap.org/img/wn/${weather.icon}@2x.png"),
                            Text("${weather.temperature} °C"),
                            Text(weather.description),
                            Text("Vent : ${weather.windSpeed} m/s"),
                            Text("Humidité : ${weather.humidity}%"),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Text("Aucune donnée météo disponible.");
                }
              },
            ),

            // Prévisions à court terme
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Prévisions à court terme :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            FutureBuilder<List<Forecast>>(
              future: _service.fetchForecast(city),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Erreur prévisions : ${snapshot.error.toString()}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Aucune prévision disponible");
                }

                final forecasts = snapshot.data!;

                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6, // les 6 prochaines heures
                    itemBuilder: (context, index) {
                      final forecast = forecasts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${forecast.dateTime.hour}h", style: TextStyle(fontWeight: FontWeight.bold)),
                              Image.network("https://openweathermap.org/img/wn/${forecast.icon}@2x.png", width: 50),
                              Text("${forecast.temperature}°C"),
                              Text(forecast.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Prévisions à long terme
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Prévisions à long terme :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            FutureBuilder<List<Forecast>>(
              future: _service.fetchForecast(city),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Erreur prévisions long terme : ${snapshot.error.toString()}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Aucune prévision disponible");
                }

                final forecasts = snapshot.data!;

                // Grouper les prévisions par jour
                final grouped = <String, List<Forecast>>{};
                for (final f in forecasts) {
                  final day = "${f.dateTime.year}-${f.dateTime.month.toString().padLeft(2, '0')}-${f.dateTime.day.toString().padLeft(2, '0')}";
                  grouped.putIfAbsent(day, () => []).add(f);
                }

                return Column(
                  children: grouped.entries.map((entry) {
                    final date = DateTime.parse(entry.key);
                    final dayName = _getDayName(date.weekday); // ex: Mardi
                    final items = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dayName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 130,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final forecast = items[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(horizontal: 6),
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("${forecast.dateTime.hour}h", style: TextStyle(fontWeight: FontWeight.bold)),
                                        Image.network("https://openweathermap.org/img/wn/${forecast.icon}@2x.png", width: 50),
                                        Text("${forecast.temperature}°C"),
                                        Text(forecast.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
