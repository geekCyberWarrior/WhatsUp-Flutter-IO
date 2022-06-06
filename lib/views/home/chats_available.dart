import 'package:flutter/material.dart';
import 'package:whats_up/api/quickblox.dart';
import 'package:whats_up/utils.dart';

class ChatsAvailableView extends StatefulWidget {
  final String userToken;
  final String userId;
  const ChatsAvailableView(
      {Key? key, required this.userToken, required this.userId})
      : super(key: key);

  @override
  State<ChatsAvailableView> createState() => _ChatsAvailableViewState();
}

class _ChatsAvailableViewState extends State<ChatsAvailableView> {
  bool isLoading = true;
  List<WhatsUpUser> users = List<WhatsUpUser>.empty();
  Future<void> setAllUsers() async {
    print("HELLO WORLD!!");
    var _users = await getAllUsers(widget.userToken, widget.userId);
    setState(() {
      users = _users;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Expanded(
            child: Center(
              child: (CircularProgressIndicator(
                color: Colors.green,
              )),
            ),
          )
        : Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      final _ = await Navigator.pushNamed(
                          context, "/chatDetail",
                          arguments: <String, String>{
                            "oppId": users[index].id,
                            "userId": widget.userId,
                            "userToken": widget.userToken,
                            "fullName": users[index].fullName,
                          });
                      await setAllUsers();
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      title: Text(
                        users[index].fullName,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        users[index].lastMessage,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10.0),
                      ),
                      trailing: Text(
                        users[index].lastMessageSent,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                  );
                },
                itemCount: users.length),
          );
  }
}
