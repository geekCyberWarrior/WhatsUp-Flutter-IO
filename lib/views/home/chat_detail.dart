import 'package:flutter/material.dart';
import 'package:whats_up/views/home/chat_wrapper.dart';

class ChatDetailView extends StatefulWidget {
  const ChatDetailView({Key? key}) : super(key: key);

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final oppId = args['oppId'];
    final userId = args['userId'];
    final userToken = args['userToken'];
    final fullName = args['fullName'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.green,
                ),
              ),
            ),
            const Icon(
              Icons.person,
              color: Colors.white,
            )
          ],
        ),
        centerTitle: false,
        title: Text(
          fullName!,
          style: const TextStyle(color: Colors.white, fontSize: 12.0),
        ),
        actions: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color(0x55559955),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.call_outlined, color: Colors.green),
                  )),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color(0x55559955),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.videocam_outlined, color: Colors.green),
                  )),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: const Color(0x55559955),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.more_vert_rounded, color: Colors.green),
                  )),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body:

          // Column(
          //   children: const [
          //     Divider(
          //       height: 5,
          //       color: Color(0xAAAAFFAA),
          //     ),
          ChatWrapperView(userToken: userToken, oppId: oppId, userId: userId),
      //   ],
      // ),
    );
  }
}
