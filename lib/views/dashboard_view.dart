import 'package:chat_boat/controllers/dashboard_controller.dart';
import 'package:chat_boat/helpers/services.dart';
import 'package:chat_boat/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _dashboarcController = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    _dashboarcController.getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[800],
        title: const Text(
          "Customer Support",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (dashboardController) {
          return _dashboarcController.chatRoomList.isEmpty
              ? Center(
                  child: Image.asset(
                    'assets/chat.png',
                    height: 200,
                    width: 200,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                      itemCount: _dashboarcController.chatRoomList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatView(
                                  chatRoomName:
                                      _dashboarcController.chatRoomList[index],
                                );
                              })).then((value) {
                                _dashboarcController.getChatRooms();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: .5, color: Colors.black)),
                              height: 40,
                              width: MediaQuery.of(context).size.width / 1,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _dashboarcController.chatRoomList[index]
                                          .split('%20')
                                          .first,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    InkWell(
                                        onTap: () async {
                                          var result = await Services()
                                              .deleteChatRoom(
                                                  _dashboarcController
                                                      .chatRoomList[index]);
                                          if (result) {
                                            _dashboarcController.chatRoomList
                                                .removeAt(index);
                                            setState(() {});
                                          }
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 30,
                                          color: Colors.green[800],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[800],
          child: Image.asset(
            'assets/chatbot.png',
            height: 40,
            width: 40,
          ),
          onPressed: () async {
            var chatRoomName = 'Untitled' + '%20' + DateTime.now().toString();
            bool result = await Services().saveChatRoom(chatRoomName);
            if (result == true) {
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChatView(
                  chatRoomName: chatRoomName,
                );
              })).then((value) {
                _dashboarcController.getChatRooms();
              });
            } else {
              print("Not working ");
            }
          }),
    );
  }
}
