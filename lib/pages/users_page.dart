import 'package:flutter/material.dart';
import 'package:fluttertask/services/service.dart';
import 'package:fluttertask/card_widgets/user_card.dart';
import 'package:fluttertask/models/user_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool isSwitched = false;
  late Future<List<User>> users;
  @override
  initState() {
    super.initState();
    users = UserService.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(Icons.people, color: Colors.blue[700], size: 32),
            onPressed: () {
              debugPrint("people icon pressed");
            },
          ),
        ),
        title: Center(
          child: Text(
            'Users',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Switch(
              value: isSwitched,
              onChanged: (val) => setState(() {
                isSwitched = val;
                debugPrint("Switch is now: $isSwitched");
              }),
              activeColor: Colors.blue[700],
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserCard(user: users[index]);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
