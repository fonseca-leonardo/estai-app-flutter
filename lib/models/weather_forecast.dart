class WeatherForecast {
  final double elevation;
  final double generationtimeMs;
  final WeatherHourly hourly;
  final WeatherHourlyUnits hourlyUnits;
  final double latitude;
  final double longitude;
  final String timezone;
  final String timezoneAbbreviation;
  final int utcOffsetSeconds;

  WeatherForecast({
    required this.elevation,
    required this.generationtimeMs,
    required this.hourly,
    required this.hourlyUnits,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.timezoneAbbreviation,
    required this.utcOffsetSeconds,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return WeatherForecast(
      elevation: (data['elevation'] as num?)?.toDouble() ?? 0.0,
      generationtimeMs: (data['generationtime_ms'] as num?)?.toDouble() ?? 0.0,
      hourly: WeatherHourly.fromJson(data['hourly'] as Map<String, dynamic>),
      hourlyUnits: WeatherHourlyUnits.fromJson(
        data['hourly_units'] as Map<String, dynamic>,
      ),
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: data['timezone'] as String? ?? '',
      timezoneAbbreviation: data['timezone_abbreviation'] as String? ?? '',
      utcOffsetSeconds: data['utc_offset_seconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'elevation': elevation,
        'generationtime_ms': generationtimeMs,
        'hourly': hourly.toJson(),
        'hourly_units': hourlyUnits.toJson(),
        'latitude': latitude,
        'longitude': longitude,
        'timezone': timezone,
        'timezone_abbreviation': timezoneAbbreviation,
        'utc_offset_seconds': utcOffsetSeconds,
      },
    };
  }
}

class WeatherHourly {
  final List<double?> dewPoint2m;
  final List<double?> precipitation;
  final List<int?> precipitationProbability;
  final List<double?> pressureMsl;
  final List<int?> relativeHumidity2m;
  final List<double?> temperature2m;
  final List<String> time;
  final List<int?> windDirection10m;
  final List<double?> windGusts10m;
  final List<double?> windSpeed10m;

  WeatherHourly({
    required this.dewPoint2m,
    required this.precipitation,
    required this.precipitationProbability,
    required this.pressureMsl,
    required this.relativeHumidity2m,
    required this.temperature2m,
    required this.time,
    required this.windDirection10m,
    required this.windGusts10m,
    required this.windSpeed10m,
  });

  factory WeatherHourly.fromJson(Map<String, dynamic> json) {
    return WeatherHourly(
      dewPoint2m:
          (json['dew_point_2m'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
      precipitation:
          (json['precipitation'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
      precipitationProbability:
          (json['precipitation_probability'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toInt())
              .toList() ??
          [],
      pressureMsl:
          (json['pressure_msl'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
      relativeHumidity2m:
          (json['relative_humidity_2m'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toInt())
              .toList() ??
          [],
      temperature2m:
          (json['temperature_2m'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
      time:
          (json['time'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      windDirection10m:
          (json['wind_direction_10m'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toInt())
              .toList() ??
          [],
      windGusts10m:
          (json['wind_gusts_10m'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
      windSpeed10m:
          (json['wind_speed_10m'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dew_point_2m': dewPoint2m,
      'precipitation': precipitation,
      'precipitation_probability': precipitationProbability,
      'pressure_msl': pressureMsl,
      'relative_humidity_2m': relativeHumidity2m,
      'temperature_2m': temperature2m,
      'time': time,
      'wind_direction_10m': windDirection10m,
      'wind_gusts_10m': windGusts10m,
      'wind_speed_10m': windSpeed10m,
    };
  }
}

class WeatherHourlyUnits {
  final String dewPoint2m;
  final String precipitation;
  final String precipitationProbability;
  final String pressureMsl;
  final String relativeHumidity2m;
  final String temperature2m;
  final String time;
  final String windDirection10m;
  final String windGusts10m;
  final String windSpeed10m;

  WeatherHourlyUnits({
    required this.dewPoint2m,
    required this.precipitation,
    required this.precipitationProbability,
    required this.pressureMsl,
    required this.relativeHumidity2m,
    required this.temperature2m,
    required this.time,
    required this.windDirection10m,
    required this.windGusts10m,
    required this.windSpeed10m,
  });

  factory WeatherHourlyUnits.fromJson(Map<String, dynamic> json) {
    return WeatherHourlyUnits(
      dewPoint2m: json['dew_point_2m'] as String? ?? '',
      precipitation: json['precipitation'] as String? ?? '',
      precipitationProbability:
          json['precipitation_probability'] as String? ?? '',
      pressureMsl: json['pressure_msl'] as String? ?? '',
      relativeHumidity2m: json['relative_humidity_2m'] as String? ?? '',
      temperature2m: json['temperature_2m'] as String? ?? '',
      time: json['time'] as String? ?? '',
      windDirection10m: json['wind_direction_10m'] as String? ?? '',
      windGusts10m: json['wind_gusts_10m'] as String? ?? '',
      windSpeed10m: json['wind_speed_10m'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dew_point_2m': dewPoint2m,
      'precipitation': precipitation,
      'precipitation_probability': precipitationProbability,
      'pressure_msl': pressureMsl,
      'relative_humidity_2m': relativeHumidity2m,
      'temperature_2m': temperature2m,
      'time': time,
      'wind_direction_10m': windDirection10m,
      'wind_gusts_10m': windGusts10m,
      'wind_speed_10m': windSpeed10m,
    };
  }
}
