import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController _emailcont = TextEditingController();
  late bool _emailVisible;

  @override
  void initState() {
    _emailVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Receive an email to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: !_emailVisible,
                        controller: _emailcont,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be kept empty';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _emailVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _emailVisible = false;
                              });
                            },
                            child: const Icon(Icons.visibility),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                resetPassword();
                              }
                            },
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              "Reset",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailcont.text.trim());
    Navigator.of(context).pop();
  }
}
