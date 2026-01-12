class MarineForecast {
  final double elevation;
  final double generationtimeMs;
  final MarineHourly hourly;
  final MarineHourlyUnits hourlyUnits;
  final double latitude;
  final double longitude;
  final String timezone;
  final String timezoneAbbreviation;
  final int utcOffsetSeconds;

  MarineForecast({
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

  factory MarineForecast.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MarineForecast(
      elevation: (data['elevation'] as num?)?.toDouble() ?? 0.0,
      generationtimeMs: (data['generationtime_ms'] as num?)?.toDouble() ?? 0.0,
      hourly: MarineHourly.fromJson(data['hourly'] as Map<String, dynamic>),
      hourlyUnits: MarineHourlyUnits.fromJson(
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

class MarineHourly {
  final List<String> time;
  final List<double?> waveDirection;
  final List<double?> waveHeight;
  final List<double?> wavePeriod;

  MarineHourly({
    required this.time,
    required this.waveDirection,
    required this.waveHeight,
    required this.wavePeriod,
  });

  factory MarineHourly.fromJson(Map<String, dynamic> json) {
    return MarineHourly(
      time:
          (json['time'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      waveDirection:
          (json['wave_direction'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
      waveHeight:
          (json['wave_height'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
      wavePeriod:
          (json['wave_period'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'wave_direction': waveDirection,
      'wave_height': waveHeight,
      'wave_period': wavePeriod,
    };
  }
}

class MarineHourlyUnits {
  final String time;
  final String waveDirection;
  final String waveHeight;
  final String wavePeriod;

  MarineHourlyUnits({
    required this.time,
    required this.waveDirection,
    required this.waveHeight,
    required this.wavePeriod,
  });

  factory MarineHourlyUnits.fromJson(Map<String, dynamic> json) {
    return MarineHourlyUnits(
      time: json['time'] as String? ?? '',
      waveDirection: json['wave_direction'] as String? ?? '',
      waveHeight: json['wave_height'] as String? ?? '',
      wavePeriod: json['wave_period'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'wave_direction': waveDirection,
      'wave_height': waveHeight,
      'wave_period': wavePeriod,
    };
  }
}
