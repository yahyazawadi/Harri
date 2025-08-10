import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertask/models/user_model.dart';

class AvatarSection extends StatelessWidget {
  const AvatarSection({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: user.avatarURL,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return Container(
                    height: 90,
                    width: 90,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: -6,
            bottom: 10,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: user.isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 94, 89, 89),
                  width: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
