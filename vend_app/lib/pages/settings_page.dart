import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vend_app/auth.dart';
import 'package:vend_app/pages/about_us_page.dart';
import 'package:vend_app/widget_tree.dart';
import 'package:vend_app/widgets/dark_mode_button.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  _MySettingsPageState createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  final User? currentUser = Auth().currentUser;

  String? _name;
  String? _firstName;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = Auth().currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _name = doc['name'];
        _firstName = doc['firstName'];
        _nameController.text = _name ?? '';
        _firstNameController.text = _firstName ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    final user = Auth().currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _nameController.text,
        'firstName': _firstNameController.text,
      });
      setState(() {
        _name = _nameController.text;
        _firstName = _firstNameController.text;
      });

      // Show a success message using a SnackBar or a dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully'),
        ),
      );
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
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

  Widget _editNameAndFirstNameButton() {
    return ElevatedButton(
      onPressed: () {
        _showEditModal(context);
      },
      child: const Text('Edit Name'),
    );
  }

  void _showEditModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
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
          const ListTile(
            title: Text('General',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const ListTile(
            title: Text('Dark Mode'),
            trailing: DarkModeToggleButton(),
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()));
            },
          ),
          const Opacity(opacity: 0.5, child: Divider()),
          const ListTile(
            title: Text('Account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          ListTile(
            title: const Text('User Information'),
            trailing: _editNameAndFirstNameButton(),
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
