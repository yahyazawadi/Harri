class TimeSlot {
  final String day;
  final String time;

  TimeSlot({required this.day, required this.time});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(day: json['day'], time: json['time']);
  }
}
