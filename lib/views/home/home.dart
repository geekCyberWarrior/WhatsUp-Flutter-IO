import 'package:flutter/material.dart';
import 'package:whats_up/views/home/chats_available.dart';
import 'package:whats_up/views/home/no_chats.dart';
import 'package:whats_up/widgets/home_menu.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int activeMenu = 0;
  bool areChatsAvailable = true;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String userToken = args['userToken'].toString();
    String userId = args['userId'].toString();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          "WhatsUp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    child: Icon(Icons.search, color: Colors.green),
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
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  icon: const Icon(Icons.power_settings_new_outlined,
                      color: Colors.green)),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                HomeMenu(
                  name: "CHATS",
                  isActive: activeMenu == 0,
                  onPressed: () {
                    setState(() {
                      activeMenu = 0;
                    });
                  },
                ),
                HomeMenu(
                  name: "STATUS",
                  isActive: activeMenu == 1,
                  onPressed: () {
                    setState(() {
                      activeMenu = 1;
                    });
                  },
                ),
                HomeMenu(
                  name: "CALLS",
                  isActive: activeMenu == 2,
                  onPressed: () {
                    setState(() {
                      activeMenu = 2;
                    });
                  },
                ),
              ],
            ),
          ),
          areChatsAvailable
              ? ChatsAvailableView(
                  userToken: userToken,
                  userId: userId,
                )
              : const NoChatsView(),
        ],
      ),
      floatingActionButton: areChatsAvailable
          ? Container()
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15.0)),
              child: const Icon(Icons.chat_bubble_outline_outlined),
              onPressed: () {
                setState(() {
                  areChatsAvailable = true;
                });
              },
            ),
    );
  }
}
