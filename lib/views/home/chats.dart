import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:whats_up/widgets/message.dart';

class ChatsView extends StatefulWidget {
  final userId;
  final messages;
  const ChatsView({Key? key, required this.userId, required this.messages})
      : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  bool _keyboardVisible = false;
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });

    return Container(
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height - (_keyboardVisible ? 350 : 200),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        controller: _controller,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Color(0x66666666),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: const Text(
                "Today",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const MessageView(
            message: "message cdsjncjkcnkjdcnjkdn cdjksncd jdcnjc dckdn",
            time: "17:00",
            isMe: false,
          ),
          const SizedBox(
            height: 10,
          ),
          for (var i = 0; i < widget.messages.length; i++) ...[
            MessageView(
                message: widget.messages[i].message,
                time: widget.messages[i].createdAt,
                isMe: widget.messages[i].fromId == widget.userId),
            const SizedBox(
              height: 10,
            ),
          ]
        ],
      ),
    );
  }
}
