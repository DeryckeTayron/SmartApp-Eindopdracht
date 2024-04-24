import 'package:vend_app/auth.dart';
import 'package:vend_app/pages/dashboard_page.dart';
import 'package:vend_app/pages/login_register_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
