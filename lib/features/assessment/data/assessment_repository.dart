import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:landiq/core/network/api_client.dart';
import 'package:landiq/features/assessment/data/assessment_model.dart';

class AssessmentRepository {
  final ApiClient _apiClient;

  AssessmentRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  // Create a new assessment
  Future<Assessment> createAssessment({
    required double latitude,
    required double longitude,
    required double areaHectares,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/assessments',
        data: {
          'latitude': latitude,
          'longitude': longitude,
          'area_hectares': areaHectares,
        },
      );
      log('CREATE ASSESSMENT: ${response.data}', name: 'AssessmentRepo');
      return Assessment.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get all saved assessments
  Future<List<Assessment>> getAssessments() async {
    try {
      final response = await _apiClient.dio.get('/assessments');
      log('GET ASSESSMENTS: ${response.data}', name: 'AssessmentRepo');

      // Handle different response shapes
      final data = response.data;
      List<dynamic> list;

      if (data is List) {
        list = data;
      } else if (data is Map && data.containsKey('assessments')) {
        list = data['assessments'] as List? ?? [];
      } else if (data is Map && data.containsKey('data')) {
        list = data['data'] as List? ?? [];
      } else {
        log('Unexpected response format: ${data.runtimeType}', name: 'AssessmentRepo');
        return [];
      }

      return list.map((e) => Assessment.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      // Return empty list for 404 (no assessments)
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw _handleError(e);
    } catch (e) {
      log('Unexpected error: $e', name: 'AssessmentRepo');
      return [];
    }
  }

  // Get a single assessment by ID
  Future<Assessment> getAssessment(String id) async {
    try {
      final response = await _apiClient.dio.get('/assessments/$id');
      log('GET ASSESSMENT: ${response.data}', name: 'AssessmentRepo');
      return Assessment.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Delete an assessment
  Future<void> deleteAssessment(String id) async {
    try {
      await _apiClient.dio.delete('/assessments/$id');
      log('DELETED ASSESSMENT $id', name: 'AssessmentRepo');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Save a temporary assessment (make it permanent)
  Future<void> saveAssessment(String id) async {
    try {
      final response = await _apiClient.dio.patch('/assessments/$id/save');
      log('SAVED ASSESSMENT: ${response.data}', name: 'AssessmentRepo');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    log('Assessment API error: ${e.response?.statusCode} ${e.response?.data}',
        name: 'AssessmentRepo');
    if (e.response?.data != null && e.response?.data is Map) {
      final data = e.response!.data as Map;
      return data['error'] ?? data['message'] ?? 'Something went wrong';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please try again.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }
    return 'Something went wrong. Please try again.';
  }
}
