import 'package:flutter/material.dart';

import 'user.dart';

/// Shows everything we know about one user.
class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final address = user.address;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          _Row(icon: Icons.person, title: 'Username', value: user.username),
          _Row(icon: Icons.email, title: 'Email', value: user.email),
          // Practice 12 will open these with url_launcher.
          _Row(
            icon: Icons.phone,
            title: 'Phone',
            value: '${user.phone}\n(digits: ${user.phoneDigits})',
            onTap: () {},
          ),
          _Row(
            icon: Icons.language,
            title: 'Website',
            value: user.website ?? 'no website',
            onTap: () {},
          ),
          _Row(
            icon: Icons.home,
            title: 'Address',
            value:
                '${address.street}, ${address.suite}\n'
                '${address.city}, ${address.zipcode}',
          ),
          _Row(
            icon: Icons.place,
            title: 'Geo',
            value: '${address.geo.lat}, ${address.geo.lng}',
          ),
          _Row(
            icon: Icons.business,
            title: 'Company',
            value: '${user.company.name}\n${user.company.catchPhrase}',
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      onTap: onTap,
    );
  }
}
