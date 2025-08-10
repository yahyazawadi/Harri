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
      name: json['name'],
      isOnline: json['isOnline'],
      avatarURL: json['avatarURL'],
      slots: (json['slots'] as List)
          .map((json) => TimeSlot.fromJson(json))
          .toList(),
    );
  }
}
