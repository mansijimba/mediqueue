import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mediqueue/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:mediqueue/features/auth/domain/entity/user_entity.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserEntity? _user;
  bool _loading = true;
  String? _error;

  late final UserRemoteDatasource _userRemoteDatasource;

  @override
  void initState() {
    super.initState();
    _userRemoteDatasource = GetIt.instance<UserRemoteDatasource>();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await _userRemoteDatasource.getCurrentUser();
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(
          'Error loading profile:\n$_error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_user == null) {
      return const Center(child: Text('No user data found.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal.shade200,
            child: Text(
              _user!.fullName.isNotEmpty
                  ? _user!.fullName[0].toUpperCase()
                  : '',
              style: const TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user!.fullName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.teal),
                    title: Text(
                      _user!.email,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.teal),
                    title: Text(
                      _user!.phone,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
