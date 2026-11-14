class ActivityLogModel {
  final String id;
  final String userId;
  final String? userName;
  final String? itemId;
  final String action;
  final Map<String, dynamic>? oldData;
  final Map<String, dynamic>? newData;
  final DateTime createdAt;

  ActivityLogModel({
    required this.id,
    required this.userId,
    this.userName,
    this.itemId,
    required this.action,
    this.oldData,
    this.newData,
    required this.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    // Handle nested profile join
    String? uName;
    if (json['profiles'] != null && json['profiles'] is Map) {
      uName = json['profiles']['full_name'] as String?;
    }

    return ActivityLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: uName,
      itemId: json['item_id'] as String?,
      action: json['action'] as String,
      oldData: json['old_data'] as Map<String, dynamic>?,
      newData: json['new_data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'item_id': itemId,
      'action': action,
      'old_data': oldData,
      'new_data': newData,
    };
  }

  String get actionLabel {
    switch (action) {
      case 'CREATE_ITEM':
        return 'Tambah Barang';
      case 'UPDATE_ITEM':
        return 'Edit Barang';
      case 'DELETE_ITEM':
        return 'Hapus Barang';
      case 'STOCK_ADJUSTMENT':
        return 'Ubah Stok';
      default:
        return action;
    }
  }
}
