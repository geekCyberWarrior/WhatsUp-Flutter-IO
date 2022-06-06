import 'package:flutter/material.dart';
import 'package:whats_up/api/quickblox.dart';
import 'package:whats_up/widgets/green_button.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterOtpView extends StatefulWidget {
  const EnterOtpView({Key? key}) : super(key: key);

  @override
  State<EnterOtpView> createState() => _EnterOtpViewState();
}

class _EnterOtpViewState extends State<EnterOtpView> {
  List<FocusNode> nodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  List<TextEditingController> smsControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  bool isLoading = false;
  int timeLeft = 60;
  late Timer timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  late String appToken;

  _getApplicationToken() async {
    String token = await getApplicationToken();
    setState(() {
      appToken = token;
    });
    print("GOT TOKEN: $token");
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft = timeLeft - 1;
        });
      } else {
        setState(() {
          timeLeft = 60;
        });
      }
    });
    _getApplicationToken();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final verificationId = args['verificationId'];
    final fullName = args['fullName'];
    final number = args['number'];
    final isSignUp = args['isSignUp'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.green,
        ),
        centerTitle: false,
        title: const Text(
          "Enter OTP Code",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(children: [
                  Expanded(flex: 2, child: Container()),
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Code has been sent to +9198******10",
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    enabled: !isLoading,
                                    autofocus: true,
                                    maxLength: 1,
                                    focusNode: nodes[0],
                                    controller: smsControllers[0],
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        nodes[0].unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(nodes[1]);
                                      }
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        fillColor: const Color(0x55555555),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 3.0))),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    enabled: !isLoading,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    focusNode: nodes[1],
                                    controller: smsControllers[1],
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        nodes[1].unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(nodes[2]);
                                      }
                                    },
                                    decoration: InputDecoration(
                                        fillColor: const Color(0x55555555),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 3.0))),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    enabled: !isLoading,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    focusNode: nodes[2],
                                    controller: smsControllers[2],
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        nodes[2].unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(nodes[3]);
                                      }
                                    },
                                    decoration: InputDecoration(
                                        fillColor: const Color(0x55555555),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 3.0))),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    enabled: !isLoading,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    focusNode: nodes[3],
                                    controller: smsControllers[3],
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        nodes[3].unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(nodes[4]);
                                      }
                                    },
                                    decoration: InputDecoration(
                                        fillColor: const Color(0x55555555),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 3.0))),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    enabled: !isLoading,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    focusNode: nodes[4],
                                    controller: smsControllers[4],
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        nodes[4].unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(nodes[5]);
                                      }
                                    },
                                    decoration: InputDecoration(
                                        fillColor: const Color(0x55555555),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 3.0))),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    enabled: !isLoading,
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    focusNode: nodes[5],
                                    controller: smsControllers[5],
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        nodes[5].unfocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                        fillColor: const Color(0x55555555),
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 20),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            borderSide: const BorderSide(
                                                color: Colors.green,
                                                width: 3.0))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Resend code in $timeLeft s",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  Expanded(flex: 2, child: Container()),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(child: Container()),
                          GreenButton(
                            value: "Verify",
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                String smsCode =
                                    smsControllers.map((e) => e.text).join();
                                final AuthCredential credential =
                                    PhoneAuthProvider.credential(
                                  verificationId: verificationId ?? '',
                                  smsCode: smsCode,
                                );
                                final User? user = (await _auth
                                        .signInWithCredential(credential))
                                    .user;
                                if (isSignUp == "1") {
                                  usersCollection
                                      .add({
                                        'name': fullName, // John Doe
                                        'number': number,
                                      })
                                      .then(
                                          (value) => print("User Added $value"))
                                      .catchError((error) =>
                                          print("Failed to add user: $error"));
                                  String login = number!;
                                  String password = number;
                                  String phone = number;
                                  await createUser(number, fullName!, appToken);
                                }
                                List<String> userDetails =
                                    await getUserSession(number!, appToken);
                                String userToken = userDetails[0];
                                String userId = userDetails[1];
                                timer.cancel();
                                Navigator.pushReplacementNamed(context, "/home",
                                    arguments: <String, String>{
                                      "userToken": userToken,
                                      "userId": userId,
                                    });
                              } catch (e) {
                                timer.cancel();
                                Navigator.pop(context);
                                print("FAILED TO SIGN IN... $e");
                              }
                            },
                            disable: isLoading,
                          ),
                          Expanded(child: Container()),
                        ],
                      )),
                ]),
              )
            ],
          ),
          isLoading
              ? const Center(
                  child: (CircularProgressIndicator(
                    color: Colors.green,
                  )),
                )
              : Container(),
        ],
      ),
    );
  }
}
