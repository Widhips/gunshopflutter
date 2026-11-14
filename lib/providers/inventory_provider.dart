import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/inventory_service.dart';
import '../services/activity_log_service.dart';

class InventoryProvider extends ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();
  final ActivityLogService _activityLogService = ActivityLogService();

  List<InventoryModel> _items = [];
  List<CategoryModel> _categories = [];
  Map<String, int> _stats = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<InventoryModel> get items => _items;
  List<CategoryModel> get categories => _categories;
  Map<String, int> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all items
  Future<void> loadItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _inventoryService.getAllItems();
    } catch (e) {
      _errorMessage = 'Gagal memuat data inventaris: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _inventoryService.getCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat kategori: $e';
      notifyListeners();
    }
  }

  /// Load dashboard stats
  Future<void> loadStats() async {
    try {
      _stats = await _inventoryService.getStats();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat statistik: $e';
      notifyListeners();
    }
  }

  /// Search items
  Future<List<InventoryModel>> searchItems(String query) async {
    try {
      return await _inventoryService.searchItems(query);
    } catch (e) {
      return [];
    }
  }

  /// Get item by ID (for QR scan)
  Future<InventoryModel?> getItemById(String id) async {
    try {
      return await _inventoryService.getItemById(id);
    } catch (e) {
      return null;
    }
  }

  /// Get item by code (for manual search)
  Future<InventoryModel?> getItemByCode(String code) async {
    try {
      return await _inventoryService.getItemByCode(code);
    } catch (e) {
      return null;
    }
  }

  /// Add new item (Admin only)
  Future<bool> addItem(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newItem = await _inventoryService.addItem(data);

      // Log activity
      await _activityLogService.logActivity(
        action: 'CREATE_ITEM',
        itemId: newItem.id,
        newData: data,
      );

      await loadItems();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah barang: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update item (Admin only)
  Future<bool> updateItem(String id, Map<String, dynamic> data, {Map<String, dynamic>? oldData}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _inventoryService.updateItem(id, data);

      // Log activity
      await _activityLogService.logActivity(
        action: 'UPDATE_ITEM',
        itemId: id,
        oldData: oldData,
        newData: data,
      );

      await loadItems();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengubah barang: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete item (Admin only)
  Future<bool> deleteItem(String id, {Map<String, dynamic>? oldData}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _inventoryService.deleteItem(id);

      // Log activity
      await _activityLogService.logActivity(
        action: 'DELETE_ITEM',
        itemId: id,
        oldData: oldData,
      );

      await loadItems();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghapus barang: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
