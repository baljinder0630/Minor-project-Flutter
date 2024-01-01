// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minor_project/Pages/nav.dart';
import 'package:minor_project/Provider/userProvider.dart';
import '../../already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../Pages/signup_screen.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  bool passToggle = true;
  bool isPatient = false;
  String role = "careTaker";
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authStateProvider).authStatus;
    return Form(
      key: _formkey,
      child: Column(
        children: [
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
                child: Icon(Icons.person),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: passToggle,
              cursorColor: kPrimaryColor,
              controller: passController,
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
          ),
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
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                print(authStatus);
                if (authStatus != AuthStatus.processing &&
                    _formkey.currentState!.validate()) {
                  var resp = await ref.read(authStateProvider.notifier).signIn(
                      email: emailController.text.trim(),
                      password: passController.text.trim(),
                      role: role);
                  log(resp.toString());
                  if (resp["success"] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Login Successful"),
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
                        content: Text("Login Failed"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: authStatus == AuthStatus.processing
                  ? CircularProgressIndicator()
                  : Text(
                      "Login".toUpperCase(),
                    ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
