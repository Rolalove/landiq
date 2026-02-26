// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentLocation _$AssessmentLocationFromJson(
  Map<String, dynamic> json,
) => AssessmentLocation(
  latitude: json['latitude'] == null ? 0 : _stringToDouble(json['latitude']),
  longitude: json['longitude'] == null ? 0 : _stringToDouble(json['longitude']),
  areaHectares: json['area_hectares'] == null
      ? 0
      : _stringToDouble(json['area_hectares']),
);

Map<String, dynamic> _$AssessmentLocationToJson(AssessmentLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'area_hectares': instance.areaHectares,
    };

SoilHealth _$SoilHealthFromJson(Map<String, dynamic> json) => SoilHealth(
  badge: json['badge'] as String?,
  totalScore: (json['total_score'] as num?)?.toInt(),
  degradationRisk: json['degradation_risk'] as String?,
);

Map<String, dynamic> _$SoilHealthToJson(SoilHealth instance) =>
    <String, dynamic>{
      'badge': instance.badge,
      'total_score': instance.totalScore,
      'degradation_risk': instance.degradationRisk,
    };

SoilProperties _$SoilPropertiesFromJson(Map<String, dynamic> json) =>
    SoilProperties(
      suitability: json['suitability'] as String?,
      drainage: json['drainage'] as String?,
      phRange: json['ph_range'] as String?,
      phDescription: json['ph_description'] as String?,
      slope: json['slope'] as String?,
      soilTexture: json['soil_texture'] as String?,
      soilDepth: json['soil_depth'] as String?,
      ecologicalZone: json['ecological_zone'] as String?,
      majorCrops: json['major_crops'] as String?,
      riskFactors: json['risk_factors'] as String?,
    );

Map<String, dynamic> _$SoilPropertiesToJson(SoilProperties instance) =>
    <String, dynamic>{
      'suitability': instance.suitability,
      'drainage': instance.drainage,
      'ph_range': instance.phRange,
      'ph_description': instance.phDescription,
      'slope': instance.slope,
      'soil_texture': instance.soilTexture,
      'soil_depth': instance.soilDepth,
      'ecological_zone': instance.ecologicalZone,
      'major_crops': instance.majorCrops,
      'risk_factors': instance.riskFactors,
    };
