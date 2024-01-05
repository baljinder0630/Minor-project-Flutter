// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/Auth/Login/login_screen.dart';
import 'package:minor_project/Pages/nav.dart';
import 'package:minor_project/Provider/userProvider.dart';
import 'package:minor_project/constants.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formkey = GlobalKey<FormState>();
  bool passToggle = true;
  bool isPatient = false;
  String role = "careTaker";

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final contactNumberController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authStateProvider).authStatus;
    return Form(
      key: _formkey,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: nameController,
                cursorColor: kPrimaryColor,
                onSaved: (firstname) {},
                decoration: InputDecoration(
                  hintText: "Name",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.person),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: emailController,
                cursorColor: kPrimaryColor,
                onSaved: (email) {},
                decoration: InputDecoration(
                  hintText: "Your email",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.email),
                  ),
                ),
                validator: (value) {
                  bool validEmail = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value!);
                  if (value.isEmpty) {
                    return "Email can't be empty";
                  } else if (!validEmail) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                obscureText: passToggle,
                controller: passController,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                    hintText: "Your password",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password can't be empty";
                  } else if (value.length < 8) {
                    return "Password must contain at least 8 characters";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                controller: contactNumberController,
                cursorColor: kPrimaryColor,
                onSaved: (firstname) {},
                decoration: InputDecoration(
                  hintText: "Phonenumber",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.phone),
                  ),
                ),
                validator: (value) {
                  if (value!.length != 10) {
                    return "Invalid Phone number";
                  }
                  return null;
                },
              ),
              // const SizedBox(height: defaultPadding / 2),
              SwitchListTile(
                title: Text(isPatient ? 'Patient' : 'Care Taker'),
                value: isPatient,
                onChanged: (bool value) {
                  setState(() {
                    isPatient = value;
                    role = isPatient ? 'patient' : 'careTaker';
                  });
                },
              ),
              // const SizedBox(height: defaultPadding / 2),
              ElevatedButton(
                onPressed: () async {
                  if (authStatus != AuthStatus.processing &&
                      _formkey.currentState!.validate()) {
                    final resp = await ref
                        .read(authStateProvider.notifier)
                        .signUp(
                            email: emailController.text.trim(),
                            password: passController.text.trim(),
                            name: nameController.text.trim(),
                            contactNumber: contactNumberController.text.trim(),
                            role: role);

                    if (resp["success"] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(resp["message"]),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Nav();
                          },
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(resp["message"]),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: authStatus == AuthStatus.processing
                    ? CircularProgressIndicator()
                    : Text(
                        "Sign Up".toUpperCase(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
