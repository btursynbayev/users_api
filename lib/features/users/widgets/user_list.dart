import 'dart:async';

import 'package:flutter/material.dart';

import '../user.dart';
import '../user_detail_screen.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.users});

  final List<User> users;

  void _openDetails(BuildContext context, User user) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => UserDetailScreen(user: user)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // Needed so pull-to-refresh works even when the list is short.
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text('${user.email} • ${user.address.city}'),
          onTap: () => _openDetails(context, user),
        );
      },
    );
  }
}
