class ReserveGoalModel {
  final String id;
  final String userId;
  final double targetAmount;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReserveGoalModel({
    required this.id,
    required this.userId,
    required this.targetAmount,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReserveGoalModel.fromMap(Map<String, dynamic> map) {
    return ReserveGoalModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      targetAmount: (map['target_amount'] as num).toDouble(),
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
