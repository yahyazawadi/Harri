import 'package:flutter/material.dart';
import 'package:fluttertask/models/user_model.dart';
import 'schedule/schedule_list.dart';

class UserContent extends StatelessWidget {
  const UserContent({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.message, size: 16, color: Colors.black),
            ],
          ),
        ),
        const SizedBox(height: 3),
        ScheduleList(user: user),
      ],
    );
  }
}
