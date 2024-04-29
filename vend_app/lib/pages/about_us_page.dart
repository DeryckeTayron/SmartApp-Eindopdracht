import 'package:flutter/material.dart';
import 'package:vend_app/pages/privacy_policy_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'VendApp',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hi, my name is Tayron. VendApp is an app I\'ve made as a school project. It enables users to locate vending machines and their contents, while also being able to put markers themselves as well. This way the users themselves can fill up the app as well.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage()),
                  );
                },
                child: const Text(
                  'Privacy & Terms',
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Contact Me:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 10),
                  Text(
                    'tayron.der@gmail.com',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.web),
                  SizedBox(width: 10),
                  Text(
                    'www.tayronderycke.com',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
