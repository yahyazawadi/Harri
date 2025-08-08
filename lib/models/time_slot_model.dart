class TimeSlot {
  final String day;
  final String time;
  TimeSlot({required this.day, required this.time});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(day: json['day'] as String, time: json['time'] as String);
  }
}
