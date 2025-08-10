import 'package:flutter/material.dart';
import 'package:fluttertask/models/time_slot_model.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({super.key, required this.slot});

  final TimeSlot slot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slot.day,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 4),
          Text(
            slot.time,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
