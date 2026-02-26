import 'package:json_annotation/json_annotation.dart';

part 'assessment_model.g.dart';

// Converts string numbers from API to doubles
double _stringToDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

@JsonSerializable()
class AssessmentLocation {
  @JsonKey(fromJson: _stringToDouble)
  final double latitude;

  @JsonKey(fromJson: _stringToDouble)
  final double longitude;

  @JsonKey(name: 'area_hectares', fromJson: _stringToDouble)
  final double areaHectares;

  const AssessmentLocation({
    this.latitude = 0,
    this.longitude = 0,
    this.areaHectares = 0,
  });

  factory AssessmentLocation.fromJson(Map<String, dynamic> json) =>
      _$AssessmentLocationFromJson(json);
  Map<String, dynamic> toJson() => _$AssessmentLocationToJson(this);
}

@JsonSerializable()
class SoilHealth {
  final String? badge;

  @JsonKey(name: 'total_score')
  final int? totalScore;

  @JsonKey(name: 'degradation_risk')
  final String? degradationRisk;

  const SoilHealth({this.badge, this.totalScore, this.degradationRisk});

  factory SoilHealth.fromJson(Map<String, dynamic> json) =>
      _$SoilHealthFromJson(json);
  Map<String, dynamic> toJson() => _$SoilHealthToJson(this);
}

@JsonSerializable()
class SoilProperties {
  final String? suitability;
  final String? drainage;

  @JsonKey(name: 'ph_range')
  final String? phRange;

  @JsonKey(name: 'ph_description')
  final String? phDescription;

  final String? slope;

  @JsonKey(name: 'soil_texture')
  final String? soilTexture;

  @JsonKey(name: 'soil_depth')
  final String? soilDepth;

  @JsonKey(name: 'ecological_zone')
  final String? ecologicalZone;

  @JsonKey(name: 'major_crops')
  final String? majorCrops;

  @JsonKey(name: 'risk_factors')
  final String? riskFactors;

  const SoilProperties({
    this.suitability,
    this.drainage,
    this.phRange,
    this.phDescription,
    this.slope,
    this.soilTexture,
    this.soilDepth,
    this.ecologicalZone,
    this.majorCrops,
    this.riskFactors,
  });

  factory SoilProperties.fromJson(Map<String, dynamic> json) =>
      _$SoilPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$SoilPropertiesToJson(this);
}

class Assessment {
  final String assessmentId;
  final String? coverage;
  final String? mappingUnit;
  final AssessmentLocation location;
  final SoilHealth soilHealth;
  final SoilProperties soilProperties;
  final String? aiExplanation;
  final String? aiExplanationStatus;
  final String? userNotes;
  final bool? isSaved;
  final bool isTemporary;
  final String? expiresAt;

  const Assessment({
    required this.assessmentId,
    this.coverage,
    this.mappingUnit,
    this.location = const AssessmentLocation(),
    this.soilHealth = const SoilHealth(),
    this.soilProperties = const SoilProperties(),
    this.aiExplanation,
    this.aiExplanationStatus,
    this.userNotes,
    this.isSaved,
    this.isTemporary = false,
    this.expiresAt,
  });

  // Handles BOTH flat (list) and nested (detail) API response shapes.
  //
  // List response:  { assessment_id, badge, total_score, latitude, ... }
  // Detail response: { assessment_id, soil_health: {badge, ...}, location: {...}, ... }
  factory Assessment.fromJson(Map<String, dynamic> json) {
    // Location: nested or flat
    AssessmentLocation loc;
    if (json.containsKey('location') && json['location'] is Map) {
      loc = AssessmentLocation.fromJson(
          json['location'] as Map<String, dynamic>);
    } else {
      loc = AssessmentLocation(
        latitude: _stringToDouble(json['latitude']),
        longitude: _stringToDouble(json['longitude']),
        areaHectares: _stringToDouble(json['area_hectares']),
      );
    }

    // Soil Health: nested or flat
    SoilHealth health;
    if (json.containsKey('soil_health') && json['soil_health'] is Map) {
      health = SoilHealth.fromJson(
          json['soil_health'] as Map<String, dynamic>);
    } else {
      health = SoilHealth(
        badge: json['badge'] as String?,
        totalScore: json['total_score'] as int?,
        degradationRisk: json['degradation_risk'] as String?,
      );
    }

    // Soil Properties: nested or flat
    SoilProperties props;
    if (json.containsKey('soil_properties') && json['soil_properties'] is Map) {
      props = SoilProperties.fromJson(
          json['soil_properties'] as Map<String, dynamic>);
    } else {
      props = const SoilProperties();
    }

    return Assessment(
      assessmentId: json['assessment_id'] as String,
      coverage: json['coverage'] as String?,
      mappingUnit: json['mapping_unit'] as String?,
      location: loc,
      soilHealth: health,
      soilProperties: props,
      aiExplanation: json['ai_explanation'] as String?,
      aiExplanationStatus: json['ai_explanation_status'] as String?,
      userNotes: json['user_notes'] as String?,
      isSaved: json['is_saved'] as bool?,
      isTemporary: json['is_temporary'] as bool? ?? true,
      expiresAt: json['expires_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'assessment_id': assessmentId,
        'coverage': coverage,
        'mapping_unit': mappingUnit,
        'location': location.toJson(),
        'soil_health': soilHealth.toJson(),
        'soil_properties': soilProperties.toJson(),
        'ai_explanation': aiExplanation,
        'ai_explanation_status': aiExplanationStatus,
        'user_notes': userNotes,
        'is_saved': isSaved,
        'is_temporary': isTemporary,
        'expires_at': expiresAt,
      };
}
