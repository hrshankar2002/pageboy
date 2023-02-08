import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_proj_1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();

  late bool _passwordVisible;
  late bool _emailVisible;
  late bool _nameVisible;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    _emailVisible = false;
    _nameVisible = false;
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
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(children: [
                    TextFormField(
                      obscureText: !_nameVisible,
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name cannot be left empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _nameVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _nameVisible = false;
                              });
                            },
                            child: const Icon(Icons.visibility),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      obscureText: !_emailVisible,
                      controller: _emailContoller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email cannot be left empty';
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
                          labelStyle: TextStyle(color: Colors.white)),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password cannot be left empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _passwordVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _passwordVisible = false;
                              });
                            },
                            child: const Icon(Icons.visibility),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white)),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              createUser();
                            }
                          },
                          color: Colors.white,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            "Sign Up",
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
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createUser() async {
    dynamic result = await _auth.createNewUser(
        _nameController.text, _emailContoller.text, _passwordController.text);
    _nameController.clear();
    _passwordController.clear();
    _emailContoller.clear();
    Navigator.of(context).pop();
  }
}
