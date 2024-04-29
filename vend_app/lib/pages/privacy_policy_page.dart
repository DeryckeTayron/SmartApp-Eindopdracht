import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            // Make content scrollable if too long
            child: Text(
              '''

**Introduction**

This Privacy Policy describes how VendApp collects, uses, and discloses your information. It also explains the choices you have associated with your data and how you can contact us.

**Information We Collect**

We may collect the following information when you use the App:

* **Personal Information:** We may collect personal information that can be used to identify you, such as your name, email address, or device identifier. However, [specify which information your app ACTUALLY collects, if any].
* **Usage Data:** We may collect information about how you use the App, such as the features you access, the pages you visit, and the time you spend on the App.
* **Location Data:** We may collect your location data with your consent to allow you to find vending machines near you. 
* **Device Information:** We may collect information about the device you use to access the App, such as the device type, operating system, and IP address.

**How We Use Your Information**

We may use the information we collect for the following purposes:

* To provide and improve the App
* To personalize your experience with the App
* To analyze how the App is used
* To comply with legal obligations

**Sharing Your Information**

We may share your information with third-party service providers who help us operate the App. We will only share your information with these providers in accordance with this Privacy Policy.

**Your Choices**

You have the following choices regarding your information:

* You can access and update your personal information through the App settings (if applicable).
* You can opt out of receiving marketing communications from us (if applicable).

**Data Retention**

We will retain your information for as long as necessary to fulfill the purposes described in this Privacy Policy. We will also retain your information as necessary to comply with legal obligations.

**Children's Privacy**

Our App is not directed to children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and you believe your child has provided us with personal information, please contact us.

**Security**

We take reasonable steps to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no internet or electronic storage system is 100% secure.

**Changes to this Privacy Policy**

We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on the App.

**Contact Us**

If you have any questions about this Privacy Policy, please contact us at tayron.der@gmail.com .

**[29/04/2024]**

''',
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ),
    );
  }
}
