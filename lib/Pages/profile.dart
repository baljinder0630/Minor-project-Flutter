import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/QrPages/qrScannerPage.dart';
import 'package:minor_project/Pages/WelcomeScreen/welcome_screen.dart';
import 'package:minor_project/Provider/settingProvider.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/to_do/widgets/display_white_text.dart';
import 'package:qr_bar_code/qr/qr.dart'; // Import your user provider

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final role = ref.watch(authStateProvider).role;

    return Scaffold(
      appBar: AppBar(
        title: const DisplayWhiteText(text: 'Settings'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileField('User Name', user.name),
                    const SizedBox(height: 10),
                    _buildProfileField('Email ID', user.email),
                    const SizedBox(height: 10),
                    _buildProfileField(
                        'Contact', user.contactNumber.toString()),
                    const SizedBox(height: 20),
                    role == Role.careTaker
                        ? _buildCareTakerWidget(context)
                        : _buildPatientWidget(context),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Add SizedBox
            Divider(),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.security),
                    title: Text(
                      'Enable Lock',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Secure your account with biometric authentication.',
                    ),
                    trailing: Consumer(builder: (context, ref, child) {
                      final state = ref.watch(settingProvider);
                      return Switch(
                        value: state.isBiometricEnabled,
                        onChanged: (v) async {
                          await ref
                              .read(settingProvider.notifier)
                              .setLocalAuth(v, context);
                        },
                      );
                    }),
                  ),
                ),
                Divider(),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(authStateProvider.notifier).logout();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WelcomeScreen()),
                                    (route) => false,
                                  );
                                },
                                child: Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  Widget _buildCareTakerWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: QRCode(
                data: ref
                    .read(authStateProvider.notifier)
                    .generateQRData()
                    .toString(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 250,
            child: const Text(
              "Scan the QR Code from the Patient's app",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientWidget(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const QRScanPage()),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text("Scan QR Code"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
