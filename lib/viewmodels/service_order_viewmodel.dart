import 'package:flutter/foundation.dart';
import '../models/service_order.dart';
import '../models/service_order_status.dart';
import '../models/service_price_item.dart';
import '../services/service_order_service.dart';

class ServiceOrderViewModel extends ChangeNotifier {
  ServiceOrderViewModel({ServiceOrderService? serviceOrderService})
    : _serviceOrderService = serviceOrderService ?? ServiceOrderService();

  final ServiceOrderService _serviceOrderService;

  List<ServiceOrder> _orders = [];
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  ServiceOrderStatus? _statusFilter;

  List<ServicePriceItem> _priceItems = [];
  bool _isLoadingPriceItems = false;
  String? _priceItemsErrorMessage;

  List<ServiceOrder> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  ServiceOrderStatus? get statusFilter => _statusFilter;

  List<ServicePriceItem> get priceItems => List.unmodifiable(_priceItems);
  bool get isLoadingPriceItems => _isLoadingPriceItems;
  String? get priceItemsErrorMessage => _priceItemsErrorMessage;

  Future<void> setStatusFilter(ServiceOrderStatus? status) async {
    if (_statusFilter == status) return;
    _statusFilter = status;
    await loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _serviceOrderService.getServiceOrders(
        status: _statusFilter,
      );
      _orders = result.items;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadPriceItems(String boatId) async {
    _isLoadingPriceItems = true;
    _priceItemsErrorMessage = null;
    _priceItems = [];
    notifyListeners();

    try {
      final result = await _serviceOrderService.getPriceItems(
        boatId: boatId,
      );
      _priceItems = result.items;
      _isLoadingPriceItems = false;
      notifyListeners();
    } catch (e) {
      _isLoadingPriceItems = false;
      _priceItemsErrorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createOrder({
    required String boatId,
    required String priceItemId,
    required String description,
    DateTime? scheduledAt,
    String? notes,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final order = await _serviceOrderService.createServiceOrder(
        boatId: boatId,
        priceItemId: priceItemId,
        description: description,
        scheduledAt: scheduledAt,
        notes: notes,
      );
      _orders.insert(0, order);
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelOrder(String id) async {
    _errorMessage = null;
    final index = _orders.indexWhere((order) => order.id == id);
    final previousOrder = index != -1 ? _orders[index] : null;

    if (index != -1) {
      _orders[index] = previousOrder!.copyWith(
        status: ServiceOrderStatus.cancelled,
      );
      notifyListeners();
    }

    try {
      final updatedOrder = await _serviceOrderService.cancelServiceOrder(id);
      if (index != -1) {
        _orders[index] = updatedOrder;
        notifyListeners();
      }
      return true;
    } catch (e) {
      if (index != -1) {
        _orders[index] = previousOrder!;
      }
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
