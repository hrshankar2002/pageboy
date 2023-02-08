import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_proj_1/dashboard_screen.dart';
import 'package:firebase_proj_1/reset_password.dart';
import 'package:firebase_proj_1/services/auth_service.dart';
import 'package:firebase_proj_1/splash_screen.dart';
import 'package:flutter/material.dart';
import 'registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      routes: {
        '/splash': (context) => const ScreenSplash(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/resetpass': (context) => const ForgotPasswordScreen()
      },
      home: ScreenSplash(),
      debugShowCheckedModeBanner: false,
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();
  int _flag = 0;
  late bool _passwordVisible;
  late bool _emailVisible;
  final AuthenticationService _auth = AuthenticationService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
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
                  'Login',
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
                        height: 30,
                      ),
                      TextFormField(
                        controller: _emailController,
                        obscureText: !_emailVisible,
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
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                            labelStyle: TextStyle(
                              color: Colors.white,
                            )),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 1),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => const RegistrationScreen(),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          "Not Registered? Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 0.5,
                      ),
                      GestureDetector(
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) =>
                                  const ForgotPasswordScreen())));
                        },
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
                                signInUser();
                              }
                            },
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              "Login",
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

  void signInUser() async {
    dynamic authResult =
        await _auth.loginUser(_emailController.text, _passwordController.text);
    if (authResult == null) {
      _emailController.clear();
      _passwordController.clear();
      _flag = 1;
    } else {
      _emailController.clear();
      _passwordController.clear();
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
}
