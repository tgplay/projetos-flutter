class ReserveContributionModel {
  final String id;
  final String userId;
  final String reserveGoalId;
  final double amount;
  final String? description;
  final DateTime contributionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReserveContributionModel({
    required this.id,
    required this.userId,
    required this.reserveGoalId,
    required this.amount,
    this.description,
    required this.contributionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReserveContributionModel.fromMap(Map<String, dynamic> map) {
    return ReserveContributionModel(
      id: (map['id'] ?? '').toString(),
      userId: (map['user_id'] ?? '').toString(),
      reserveGoalId: (map['reserve_goal_id'] ?? '').toString(),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      description: map['description']?.toString(),
      contributionDate:
          DateTime.tryParse(map['contribution_date']?.toString() ?? '') ??
          DateTime.now(),
      createdAt:
          DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
