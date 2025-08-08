import 'package:fluttertask/models/time_slot_model.dart';

class User {
  final String name;
  final bool isOnline;
  final String avatarURL;
  final List<TimeSlot> slots;

  User({
    required this.name,
    required this.isOnline,
    required this.avatarURL,
    required this.slots,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      isOnline: json['isOnline'] as bool,
      avatarURL: json['avatarURL'] as String,
      slots: (json['slots'] as List)
          .map((slot) => TimeSlot.fromJson(slot as Map<String, dynamic>))
          .toList(),
    );
  }
}
