class PromotionApplication {
  String id;
  String name;
  String description;
  String fromDate;
  String toDate;
  String currentStatus;

  PromotionApplication({
    this.id,
    this.name,
    this.description,
    this.fromDate,
    this.toDate,
    this.currentStatus,
  });

  factory PromotionApplication.fromJson(Map<String, dynamic> json) {
    return PromotionApplication(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      fromDate: json['from_date'] as String,
      toDate: json['to_date'] as String,
      currentStatus: json['current_status'] as String,
    );
  }
}
