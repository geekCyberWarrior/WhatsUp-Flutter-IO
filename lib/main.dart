import 'package:flutter/material.dart';
import 'package:whats_up/views/home/chat_detail.dart';
import 'package:whats_up/views/home/home.dart';
import 'package:whats_up/views/enter_otp.dart';
import 'package:whats_up/views/sign_in.dart';
import 'package:whats_up/views/sign_up.dart';
import 'package:whats_up/views/start.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: "/",
    debugShowCheckedModeBanner: false,
    routes: {
      "/": (context) => const StartView(),
      "/signin": (context) => const SignInView(),
      "/signup": (context) => const SignUpView(),
      "/enterOtp": (context) => const EnterOtpView(),
      "/home": (context) => const HomeView(),
      "/chatDetail": (context) => const ChatDetailView(),
    },
  ));
}
