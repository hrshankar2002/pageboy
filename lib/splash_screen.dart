import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_proj_1/dashboard_screen.dart';
import 'package:firebase_proj_1/main.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkifLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    gotoHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      Image(
        image: AssetImage('assets/images/img.png'),
        fit: BoxFit.cover,
      ),
      // other irrelevent children here
    ]);
  }

  Future<void> gotoHome() async {
    await checkifLogin();
    await Future.delayed(const Duration(seconds: 3));
    if (isLogin == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const DashboardScreen())));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((context) => const LoginScreen())));
    }
  }
}
