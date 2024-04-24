import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vend_app/auth.dart';

// ignore: use_key_in_widget_constructors
class MySettingsPage extends StatelessWidget {
  final User? currentUser = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Settings');
  }

  Widget _userUid() {
    return Text(currentUser?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: // Replace with logic to check current dark mode setting
                  false, // Placeholder, replace with your dark mode state
              onChanged: (value) {
                // Implement logic to toggle dark mode
              },
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: Checkbox(
              value: // Replace with logic to check current notification setting
                  true, // Placeholder, replace with your notification state
              onChanged: (value) {
                // Implement logic to toggle notifications
              },
            ),
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: () {
              // Navigate to About Us page (optional)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MyAboutUsPage()));
            },
          ),
          ListTile(
            title: Text(currentUser?.email ??
                'Not Logged In'), // Display user email or "Not Logged In"
            trailing: _signOutButton(),
          ),
        ],
      ),
    );
  }
}
