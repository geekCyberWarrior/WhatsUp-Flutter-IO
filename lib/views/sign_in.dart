import 'package:flutter/material.dart';
import 'package:whats_up/utils.dart';
import 'package:whats_up/widgets/green_button.dart';
import 'package:whats_up/widgets/icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool rememberMe = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController numberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(flex: 1, child: IconView(name: "WhatsUp")),
                Expanded(
                    flex: 1,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign in to your account",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 5.0),
                                  child: RichText(
                                    text: const TextSpan(
                                        text: "Phone Number",
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                              text: " *",
                                              style:
                                                  TextStyle(color: Colors.red))
                                        ]),
                                  )),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                autofocus: true,
                                validator: (value) {
                                  return isValidPhoneNumber(value);
                                },
                                controller: numberController,
                                decoration: InputDecoration(
                                    fillColor: const Color(0x55555555),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    hintText: "Phone Number",
                                    hintStyle: const TextStyle(
                                        color: Color(0x88888888),
                                        fontWeight: FontWeight.bold),
                                    prefixIcon: const Icon(
                                      Icons.call_outlined,
                                      color: Color(0xBBBBBBBB),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: const BorderSide(
                                            color: Colors.green, width: 3.0))),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  fillColor:
                                      MaterialStateProperty.all(Colors.green),
                                  value: rememberMe,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      rememberMe = newValue!;
                                    });
                                  }),
                              const Text(
                                "Remember me",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          GreenButton(
                            value: "Sign In",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var value = await usersCollection
                                    .where('number',
                                        isEqualTo: numberController.text)
                                    .get();

                                if (value.docs.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("User Does Not Exist")));
                                } else {
                                  print(
                                      "PRESSED!!! +91${numberController.text}");
                                  await _auth.verifyPhoneNumber(
                                      phoneNumber:
                                          "+91${numberController.text}",
                                      verificationCompleted: (cred) {
                                        print("COMPLETED: $cred");
                                      },
                                      verificationFailed: (e) {
                                        print("ERROR: $e");
                                      },
                                      codeSent: (s, i) async {
                                        Navigator.pushNamed(
                                            context, "/enterOtp",
                                            arguments: <String, String>{
                                              "verificationId": s,
                                              "fullName": value.docs.first
                                                  .get("name"),
                                              "number": value.docs.first
                                                  .get("number"),
                                              "isSignUp": "0",
                                            });
                                      },
                                      codeAutoRetrievalTimeout: (s) {
                                        print("HELLO WORLD $s!!!");
                                      });
                                }
                                _formKey.currentState?.reset();
                                // Navigator.pushNamed(context, "/enterOtp");
                              }
                            },
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/signup");
                                },
                                child: const Text(
                                  " Sign Up",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
