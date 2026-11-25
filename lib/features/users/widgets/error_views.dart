import 'package:flutter/material.dart';

/// One base widget: icon + title + text + optional Retry button.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}

/// NoConnectionException: airplane mode, wrong host, 10-second timeout.
class OfflineView extends StatelessWidget {
  const OfflineView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.wifi_off,
      title: 'You are offline',
      message: 'Check your internet connection and try again.',
      onRetry: onRetry,
    );
  }
}

/// ServerException: their server is broken (5xx). Retry may help.
class ServerErrorView extends StatelessWidget {
  const ServerErrorView({
    super.key,
    required this.status,
    required this.onRetry,
  });

  final int status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.cloud_off,
      title: 'Server problem',
      message: 'The server answered with status $status.',
      onRetry: onRetry,
    );
  }
}

/// NotFoundException / UnauthorizedException: my request was refused (4xx).
/// Retry will not help, so there is no button.
class RequestRefusedView extends StatelessWidget {
  const RequestRefusedView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MessageView(
      icon: Icons.block,
      title: 'Request refused',
      message: 'The server does not allow this request.',
    );
  }
}

/// BadResponseException: JSON we could not read. It is a bug, not a Retry.
class GenericError extends StatelessWidget {
  const GenericError({super.key});

  @override
  Widget build(BuildContext context) {
    return const MessageView(
      icon: Icons.bug_report,
      title: 'Something went wrong',
      message: 'The server answer could not be read.',
    );
  }
}
