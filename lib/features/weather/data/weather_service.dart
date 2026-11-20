// lib/features/weather/data/weather_service.dart

import 'package:dio/dio.dart';
import '../domain/clima.dart';

class WeatherService {
  // Coordenadas de Tizimín, Yucatán
  static const double defaultLat = 21.15;
  static const double defaultLon = -88.15;

  final Dio _dio = Dio();

  Future<ClimaCompleto?> obtenerClima(double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current':
              'temperature_2m,relative_humidity_2m,wind_speed_10m,precipitation',
          'daily':
              'temperature_2m_max,temperature_2m_min,precipitation_probability_max,precipitation_sum',
          'timezone': 'auto',
        },
      );

      if (response.statusCode == 200) {
        return ClimaCompleto.fromJson(response.data);
      } else {
        print('Error al obtener clima: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción en WeatherService: $e');
      return null;
    }
  }
}
