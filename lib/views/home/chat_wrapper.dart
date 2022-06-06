import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whats_up/api/quickblox.dart';
import 'package:whats_up/utils.dart';
import 'package:whats_up/views/home/chats.dart';

class ChatWrapperView extends StatefulWidget {
  final userToken;
  final oppId;
  final userId;
  const ChatWrapperView(
      {Key? key,
      required this.userToken,
      required this.oppId,
      required this.userId})
      : super(key: key);

  @override
  State<ChatWrapperView> createState() => _ChatWrapperViewState();
}

class _ChatWrapperViewState extends State<ChatWrapperView> {
  bool _keyboardVisible = false;
  var messageController = TextEditingController();
  var icon = const Icon(
    Icons.mic,
    color: Colors.white,
  );
  List<Message> messages = List<Message>.empty();
  late Timer timer;
  late String dialogId;
  var isLoading = true;

  _loadMessages() async {
    var _dialogId = await createDialog(widget.userToken, widget.oppId);
    List<Message> msgs = await getMessages(_dialogId, widget.userToken);
    setState(() {
      dialogId = _dialogId;
      messages = msgs;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      var _messages = await getMessages(dialogId, widget.userToken);
      setState(() {
        messages = _messages;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                (_keyboardVisible ? 350 : 200),
            child: const Center(
              child: (CircularProgressIndicator(
                color: Colors.green,
              )),
            ),
          )
        : Stack(
            children: [
              ChatsView(
                userId: widget.userId,
                messages: messages,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: _keyboardVisible ? 20 : 40),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.white),
                            controller: messageController,
                            onChanged: (value) {
                              setState(() {
                                icon = value == ""
                                    ? const Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      );
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: const Color(0x55555555),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              hintText: "Type message...",
                              hintStyle:
                                  const TextStyle(color: Color(0x88888888)),
                              prefixIcon: const Icon(
                                Icons.emoji_emotions_outlined,
                                color: Color(0xBBBBBBBB),
                              ),
                              suffixIcon: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 3.0),
                                    child: Icon(
                                      Icons.attach_file,
                                      color: Color(0xBBBBBBBB),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Color(0xBBBBBBBB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          child: IconButton(
                              onPressed: () async {
                                String msgToSend = messageController.text;
                                messageController.clear();
                                DateTime now = DateTime.now().toUtc();
                                String formattedDate =
                                    DateFormat('yyyy-MM-ddTkk:mm:ss')
                                            .format(now) +
                                        "Z";
                                setState(() {
                                  icon = const Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                  );
                                  messages = [
                                    ...messages,
                                    Message(
                                        message: msgToSend,
                                        fromId: widget.userId,
                                        toId: widget.oppId,
                                        createdAt: formattedDate)
                                  ];
                                });
                                await sendMessage(widget.oppId!, msgToSend,
                                    widget.userToken!);
                              },
                              icon: icon),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
