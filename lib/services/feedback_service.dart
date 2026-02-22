import 'maps_api_client.dart';

class FeedbackService {
  final MapsApiClient _apiClient;

  FeedbackService({MapsApiClient? apiClient})
      : _apiClient = apiClient ?? MapsApiClient();

  Future<void> sendFeedback(String feedback) async {
    final response = await _apiClient.post(
      '/feedback',
      body: {'feedback': feedback},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(
        'Failed to send feedback: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}
