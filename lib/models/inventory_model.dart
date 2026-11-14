class InventoryModel {
  final String id;
  final String itemCode;
  final String name;
  final String? categoryId;
  final String? categoryName;
  final String? description;
  final int stock;
  final String? location;
  final String? qrCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryModel({
    required this.id,
    required this.itemCode,
    required this.name,
    this.categoryId,
    this.categoryName,
    this.description,
    required this.stock,
    this.location,
    this.qrCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    // Handle nested category join
    String? catName;
    if (json['categories'] != null && json['categories'] is Map) {
      catName = json['categories']['name'] as String?;
    }

    return InventoryModel(
      id: json['id'] as String,
      itemCode: json['item_code'] as String,
      name: json['name'] as String,
      categoryId: json['category_id'] as String?,
      categoryName: catName,
      description: json['description'] as String?,
      stock: json['stock'] as int? ?? 0,
      location: json['location'] as String?,
      qrCode: json['qr_code'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'name': name,
      'category_id': categoryId,
      'description': description,
      'stock': stock,
      'location': location,
      'qr_code': qrCode,
    };
  }

  InventoryModel copyWith({
    String? id,
    String? itemCode,
    String? name,
    String? categoryId,
    String? categoryName,
    String? description,
    int? stock,
    String? location,
    String? qrCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      location: location ?? this.location,
      qrCode: qrCode ?? this.qrCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
