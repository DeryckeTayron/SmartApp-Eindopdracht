import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vend_app/auth.dart';
import 'package:vend_app/widget_tree.dart';
import 'package:vend_app/widgets/dark_mode_button.dart';

class MySettingsPage extends StatefulWidget {
  @override
  _MySettingsPageState createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  final User? currentUser = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.pushAndRemoveUntil(
      // Use Navigator.pushReplacement
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
      (Route<dynamic> route) => false,
    );
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: _title(),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: DarkModeToggleButton(),
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: () {
              // Navigate to About Us page (optional)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MyAboutUsPage()));
            },
          ),
          ListTile(
            title: _userUid(),
            trailing: _signOutButton(),
          ),
        ],
      ),
    );
  }
}
