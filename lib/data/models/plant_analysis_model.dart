class PlantAnalysisModel {
  final String plantName;
  final String scientificName;
  final String family;
  final String origin;
  final String countries;
  final String environment;
  final String temperature;
  final String humidity;
  final String soil;
  final String sunlight;
  final String wateringSchedule;
  final String fertilizerSchedule;
  final String healthStatus;
  final String diseaseName;
  final double confidence;
  final String diseaseCause;
  final String symptoms;
  final String treatment;
  final String prevention;
  final String toxicity;
  final String growthRate;
  final String lifespan;
  final String generalCareTips;

  PlantAnalysisModel({
    required this.plantName,
    required this.scientificName,
    required this.family,
    required this.origin,
    required this.countries,
    required this.environment,
    required this.temperature,
    required this.humidity,
    required this.soil,
    required this.sunlight,
    required this.wateringSchedule,
    required this.fertilizerSchedule,
    required this.healthStatus,
    required this.diseaseName,
    required this.confidence,
    required this.diseaseCause,
    required this.symptoms,
    required this.treatment,
    required this.prevention,
    required this.toxicity,
    required this.growthRate,
    required this.lifespan,
    required this.generalCareTips,
  });

  factory PlantAnalysisModel.fromJson(Map<String, dynamic> json) {
    return PlantAnalysisModel(
      plantName: json['plantName'] ?? '',
      scientificName: json['scientificName'] ?? '',
      family: json['family'] ?? '',
      origin: json['origin'] ?? '',
      countries: json['countries'] ?? '',
      environment: json['environment'] ?? '',
      temperature: json['temperature'] ?? '',
      humidity: json['humidity'] ?? '',
      soil: json['soil'] ?? '',
      sunlight: json['sunlight'] ?? '',
      wateringSchedule: json['wateringSchedule'] ?? '',
      fertilizerSchedule: json['fertilizerSchedule'] ?? '',
      healthStatus: json['healthStatus'] ?? '',
      diseaseName: json['diseaseName'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      diseaseCause: json['diseaseCause'] ?? '',
      symptoms: json['symptoms'] ?? '',
      treatment: json['treatment'] ?? '',
      prevention: json['prevention'] ?? '',
      toxicity: json['toxicity'] ?? '',
      growthRate: json['growthRate'] ?? '',
      lifespan: json['lifespan'] ?? '',
      generalCareTips: json['generalCareTips'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantName': plantName,
      'scientificName': scientificName,
      'family': family,
      'origin': origin,
      'countries': countries,
      'environment': environment,
      'temperature': temperature,
      'humidity': humidity,
      'soil': soil,
      'sunlight': sunlight,
      'wateringSchedule': wateringSchedule,
      'fertilizerSchedule': fertilizerSchedule,
      'healthStatus': healthStatus,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'diseaseCause': diseaseCause,
      'symptoms': symptoms,
      'treatment': treatment,
      'prevention': prevention,
      'toxicity': toxicity,
      'growthRate': growthRate,
      'lifespan': lifespan,
      'generalCareTips': generalCareTips,
    };
  }
}
