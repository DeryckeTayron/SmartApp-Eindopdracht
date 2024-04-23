import 'package:flutter/material.dart';

class MySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
        ],
      ),
    );
  }
}
