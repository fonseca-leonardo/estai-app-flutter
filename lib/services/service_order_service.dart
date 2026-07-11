import 'dart:convert';
import '../models/service_order.dart';
import '../models/service_order_status.dart';
import '../models/service_price_item.dart';
import 'estai_api_client.dart';

class ServiceOrderListResult {
  final List<ServiceOrder> items;
  final int total;
  final int page;
  final int limit;

  ServiceOrderListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}

class PriceItemListResult {
  final List<ServicePriceItem> items;
  final int total;
  final int page;
  final int limit;

  PriceItemListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });
}

String? _extractErrorMessage(String body) {
  try {
    final jsonData = json.decode(body) as Map<String, dynamic>;
    return jsonData['message'] as String?;
  } catch (_) {
    return null;
  }
}

/// Consome os endpoints de ordens de serviço (`/service-orders`) da API do
/// Estai.
class ServiceOrderService {
  final EstaiApiClient _apiClient;

  ServiceOrderService({EstaiApiClient? apiClient})
    : _apiClient = apiClient ?? EstaiApiClient.instance;

  Future<ServiceOrderListResult> getServiceOrders({
    int page = 1,
    int limit = 50,
    ServiceOrderStatus? status,
    String? boatId,
    String? search,
  }) async {
    try {
      final response = await _apiClient.get(
        '/service-orders',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status.apiValue,
          if (boatId != null) 'boatId': boatId,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        final items = (data['items'] as List<dynamic>)
            .map((item) => ServiceOrder.fromJson(item as Map<String, dynamic>))
            .toList();

        return ServiceOrderListResult(
          items: items,
          total: data['total'] as int,
          page: data['page'] as int,
          limit: data['limit'] as int,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load service orders: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading service orders: $e');
    }
  }

  Future<PriceItemListResult> getPriceItems({
    required String boatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get(
        '/service-orders/price-items',
        queryParameters: {'boatId': boatId, 'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        final items = (data['items'] as List<dynamic>)
            .map(
              (item) =>
                  ServicePriceItem.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        return PriceItemListResult(
          items: items,
          total: data['total'] as int,
          page: data['page'] as int,
          limit: data['limit'] as int,
        );
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to load price items: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error loading price items: $e');
    }
  }

  Future<ServiceOrder> createServiceOrder({
    required String boatId,
    required String priceItemId,
    required String description,
    DateTime? scheduledAt,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post(
        '/service-orders',
        body: {
          'boatId': boatId,
          'priceItemId': priceItemId,
          'description': description,
          if (scheduledAt != null)
            'scheduledAt': scheduledAt.toUtc().toIso8601String(),
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        return ServiceOrder.fromJson(data);
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to create service order: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error creating service order: $e');
    }
  }

  Future<ServiceOrder> cancelServiceOrder(String id) async {
    try {
      final response = await _apiClient.patch('/service-orders/$id/cancel');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw ApiException('Invalid response: data field is null');
        }

        return ServiceOrder.fromJson(data);
      } else {
        throw ApiException(
          _extractErrorMessage(response.body) ??
              'Failed to cancel service order: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Error cancelling service order: $e');
    }
  }
}
