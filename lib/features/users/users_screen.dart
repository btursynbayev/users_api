import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import '../settings/settings_model.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();
    final settings = context.watch<SettingsModel>();

    var list = model.items;
    if (settings.city != null) {
      list = list.where((u) => u.address.city == settings.city).toList();
    }

    if (model.loading && model.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (model.error != null && model.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorText(model.error!)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<UsersModel>().load(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (model.fromCache)
          MaterialBanner(
            content: const Text('Saved data · no connection'),
            actions: [
              TextButton(
                onPressed: () => context.read<UsersModel>().load(),
                child: const Text('Retry'),
              ),
            ],
          ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final user = list[i];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.address.city),
              );
            },
          ),
        ),
      ],
    );
  }

  String _errorText(ApiException e) => switch (e) {
    NoConnectionException() => 'No connection',
    ServerException() => 'Server error',
    NotFoundException() => 'Not found',
    UnauthorizedException() => 'Unauthorized',
    BadResponseException() => 'Bad response',
  };
}
