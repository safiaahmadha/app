class DashboardInstance {
  String id;
  String totalSales;
  String completed;
  String inProgress;
  String canceled;
  String closed;
  String lat;
  String long;
  String checkIn;
  String checkOut;
  String eventType;
  String dateTime;

  DashboardInstance({
    this.id,
    this.totalSales,
    this.completed,
    this.inProgress,
    this.canceled,
    this.closed,
    this.checkIn,
    this.checkOut,
    this.lat,
    this.long,
  this.eventType,
  this.dateTime
  });

  factory DashboardInstance.fromJson(Map<String, dynamic> json) {
    return DashboardInstance(
      id: json['id'] as String,
      totalSales: json['total_sales'] as String,
      completed: json['completed'] as String,
      inProgress: json['inprogress'] as String,
      canceled: json['cancled'] as String,
      closed: json['closed'] as String,
      checkIn: json['check_in'] as String,
      checkOut: json['check_out'] as String,
      lat: json['latitude'] as String,
      long: json['longitude'] as String,
      eventType: json['event_type'] as String,
      dateTime: json['date_time'] as String,
    );
  }
}
