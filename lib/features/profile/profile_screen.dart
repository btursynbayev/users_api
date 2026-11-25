import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatar;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final prefs = SharedPreferencesAsync();
    final path = await prefs.getString('avatarPath');
    if (path != null && File(path).existsSync()) {
      if (mounted) setState(() => _avatar = File(path));
    }
  }

  Future<void> _savePhoto(XFile picked) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = await File(picked.path).copy('${dir.path}/avatar.jpg');
    final prefs = SharedPreferencesAsync();
    await prefs.setString('avatarPath', file.path);
    if (mounted) setState(() => _avatar = file);
  }

  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;
    await _savePhoto(picked);
  }

  Future<void> _takePhoto() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;
      await _savePhoto(picked);
    } else if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Camera permission'),
            content: const Text('Please enable camera access in settings.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  unawaited(openAppSettings());
                },
                child: const Text('Open settings'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
              child: _avatar == null
                  ? const Icon(Icons.person, size: 64)
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _pickFromGallery,
              child: const Text('Choose photo'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}
