import 'package:flutter/material.dart';
import 'package:fluttertask/models/user_model.dart';
import 'schedule_item.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    if (user.slots.isEmpty) {
      return const Text(
        'No available slots',
        style: TextStyle(color: Colors.grey),
      );
    }

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: user.slots.length,
        separatorBuilder: (context, index) => Container(
          width: 1,
          height: double.infinity,
          color: Colors.grey[300],
        ),
        itemBuilder: (context, index) {
          return ScheduleItem(slot: user.slots[index]);
        },
      ),
    );
  }
}
