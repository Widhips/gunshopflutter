import 'supabase_service.dart';
import '../models/models.dart';

class InventoryService {
  final _client = SupabaseService.client;

  /// Get all inventory items with category name
  Future<List<InventoryModel>> getAllItems() async {
    final response = await _client
        .from('inventory')
        .select('*, categories(name)')
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => InventoryModel.fromJson(item))
        .toList();
  }

  /// Get item by ID
  Future<InventoryModel?> getItemById(String id) async {
    final response = await _client
        .from('inventory')
        .select('*, categories(name)')
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return InventoryModel.fromJson(response);
  }

  /// Get item by item_code (SKU)
  Future<InventoryModel?> getItemByCode(String code) async {
    final response = await _client
        .from('inventory')
        .select('*, categories(name)')
        .eq('item_code', code)
        .maybeSingle();

    if (response == null) return null;
    return InventoryModel.fromJson(response);
  }

  /// Search items by name or code
  Future<List<InventoryModel>> searchItems(String query) async {
    final response = await _client
        .from('inventory')
        .select('*, categories(name)')
        .or('name.ilike.%$query%,item_code.ilike.%$query%')
        .order('name');

    return (response as List)
        .map((item) => InventoryModel.fromJson(item))
        .toList();
  }

  /// Add new item (Admin only)
  Future<InventoryModel> addItem(Map<String, dynamic> data) async {
    final response = await _client
        .from('inventory')
        .insert(data)
        .select('*, categories(name)')
        .single();

    return InventoryModel.fromJson(response);
  }

  /// Update item (Admin only)
  Future<InventoryModel> updateItem(String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('inventory')
        .update(data)
        .eq('id', id)
        .select('*, categories(name)')
        .single();

    return InventoryModel.fromJson(response);
  }

  /// Delete item (Admin only)
  Future<void> deleteItem(String id) async {
    await _client.from('inventory').delete().eq('id', id);
  }

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .order('name');

    return (response as List)
        .map((item) => CategoryModel.fromJson(item))
        .toList();
  }

  /// Get inventory statistics
  Future<Map<String, int>> getStats() async {
    final items = await _client.from('inventory').select('stock');
    final categories = await _client.from('categories').select('id');

    int totalItems = (items as List).length;
    int totalStock = 0;
    for (var item in items) {
      totalStock += (item['stock'] as int? ?? 0);
    }
    int totalCategories = (categories as List).length;

    return {
      'totalItems': totalItems,
      'totalStock': totalStock,
      'totalCategories': totalCategories,
    };
  }
}
