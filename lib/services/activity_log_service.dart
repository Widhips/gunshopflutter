import 'supabase_service.dart';
import '../models/activity_log_model.dart';

class ActivityLogService {
  final _client = SupabaseService.client;

  /// Log an activity
  Future<void> logActivity({
    required String action,
    String? itemId,
    Map<String, dynamic>? oldData,
    Map<String, dynamic>? newData,
  }) async {
    final userId = SupabaseService.currentUserId;
    if (userId == null) return;

    await _client.from('activity_logs').insert({
      'user_id': userId,
      'item_id': itemId,
      'action': action,
      'old_data': oldData,
      'new_data': newData,
    });
  }

  /// Get all activity logs (Admin only)
  Future<List<ActivityLogModel>> getActivityLogs({int limit = 50}) async {
    final response = await _client
        .from('activity_logs')
        .select('*, profiles(full_name)')
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((item) => ActivityLogModel.fromJson(item))
        .toList();
  }
}
