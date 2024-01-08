// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/nav.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/models/assignedPatient.dart';
import 'package:qr_bar_code/qr/qr.dart';

class QrCodePage extends ConsumerStatefulWidget {
  const QrCodePage({super.key});

  @override
  ConsumerState<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends ConsumerState<QrCodePage> {
  @override
  void initState() {
    // TODO: implement initState
    // getAssignedPatients();

    super.initState();
  }

  refresh() async {
    await ref.watch(authStateProvider.notifier).getAssignedPatients();
  }

  @override
  Widget build(BuildContext context) {
    final assignedPatients =
        ref.watch(authStateProvider.notifier).state.user.assignedPatients ?? [];
    final careTakerId = ref.watch(authStateProvider).user.id;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                  height: 250,
                  child: QRCode(
                      data: host +
                          "/allocateCaretaker/?caretakerId=$careTakerId&")),
              SizedBox(height: 20),
              Text("Scan the QR Code from Patient's app"),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await refresh();
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: assignedPatients.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: ref
                            .read(authStateProvider.notifier)
                            .getPatientInfo(assignedPatients[index], "patient"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return ListTile(
                              onTap: () {
                                ref
                                    .watch(authStateProvider.notifier)
                                    .selectCurrentPatient(CurrentPatient(
                                        name: snapshot.data["name"],
                                        email: snapshot.data["email"],
                                        id: snapshot.data["userId"]));

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Nav()));
                              },
                              title: Text(snapshot.data["name"]),
                              subtitle: Text(snapshot.data["email"]),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
