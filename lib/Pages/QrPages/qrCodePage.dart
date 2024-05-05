import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/Pages/nav.dart';
import 'package:minor_project/Pages/profile.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/models/assignedPatient.dart';
import 'package:minor_project/models/user_model.dart';
import 'package:minor_project/to_do/widgets/display_white_text.dart';
import 'package:qr_bar_code/qr/qr.dart';

class QrCodePage extends ConsumerStatefulWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  ConsumerState<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends ConsumerState<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    final careTakerId = ref.watch(authStateProvider).user.id;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingPage(),
            ),
          );
        },
        child: const Icon(Icons.settings),
      ),
      appBar: AppBar(
        title: const DisplayWhiteText(text: 'AlzHub'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
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
            const Text(
              "Scan the QR Code from the Patient's app",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('patients')
                    .where(
                      "caretakerId",
                      isEqualTo: careTakerId,
                    )
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.docs.isEmpty) {
                    return const Text("No Patients Assigned",
                        style: TextStyle(fontSize: 16));
                  } else {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot patientDoc =
                            snapshot.data!.docs[index];
                        Map<String, dynamic> patientData =
                            patientDoc.data() as Map<String, dynamic>;

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(patientData['patientId'])
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> userData =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              UserModel user = UserModel(
                                email: userData['email'],
                                id: patientData['patientId'],
                                name: userData['name'],
                                role: userData['role'],
                                contactNumber: userData['contactNumber'],
                              );
                              return patientData["type"] == "rejected"
                                  ? Container()
                                  : ListTile(
                                      onTap: () {
                                        if (patientData["type"] == "accepted") {
                                          ref
                                              .read(authStateProvider.notifier)
                                              .selectCurrentPatient(
                                                  CurrentPatient(
                                                email: userData['email'],
                                                name: userData['name'],
                                                id: patientData['patientId'],
                                              ));
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => const Nav(),
                                            ),
                                          );
                                        }
                                      },
                                      trailing: patientData["type"] == "request"
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    await ref
                                                        .read(authStateProvider
                                                            .notifier)
                                                        .updatePatientType(
                                                          patientId:
                                                              patientData[
                                                                  'patientId'],
                                                          type: 'accepted',
                                                        );
                                                  },
                                                  icon: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green,
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      weight: 30,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    ref
                                                        .read(authStateProvider
                                                            .notifier)
                                                        .updatePatientType(
                                                          patientId:
                                                              patientData[
                                                                  'patientId'],
                                                          type: 'rejected',
                                                        );
                                                  },
                                                  icon: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: Colors.grey,
                                            ),
                                      title: Text(user.name),
                                      subtitle: Text(user.email),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                          user.name[0],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                            } else if (snapshot.connectionState ==
                                ConnectionState.none) {
                              return const Text("No data");
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
