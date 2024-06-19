import 'package:chat_boat/controllers/chat_view_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:chat_boat/views/widgets/chat_item_widget.dart';
import 'package:chat_boat/views/widgets/chat_text_field_widget.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  String chatRoomName;
  ChatView({required this.chatRoomName});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String currentChatRoomName='';
  final _chatViewController=Get.put(ChatViewController());

  
  
  @override
  void initState() {
    _chatViewController.currentChatRoomName=widget.chatRoomName;
  _chatViewController.getMessage(
    chatRoomName:
    widget.chatRoomName,
    context:
    context);
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:  const Icon(
              Icons.navigate_before_rounded,
              size: 30,
              color: Colors.white,
            )),
        elevation: 0,
        backgroundColor: Colors.green[800],
        title: GetBuilder<ChatViewController>(
          init: ChatViewController(),
          builder: (chatViewController) {
            return InkWell(
              onTap: () {
              chatViewController.showEnterChatRoomPopup(
                currentChatRoom:
                widget.chatRoomName,context:context);
              },
              child:  Text(
            chatViewController.currentChatRoomName.split('%20').first ,
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }
        ),
      ),
      body: GetBuilder<ChatViewController>(
        init: ChatViewController(),
        builder: (chatViewCotroller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.25,
                  child: ListView.builder(
                     controller: chatViewCotroller.scrollController,
                      itemCount: chatViewCotroller.messages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: ChatItemWidget(
                            message:chatViewCotroller. messages[index].message,
                            time: chatViewCotroller.messages[index].time,
                            isMe: chatViewCotroller.messages[index].isMe,
                          ),
                        );
                      }),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 12,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(width: .5, color: Colors.black12))),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ChatTextField(
                        onSend: (value) {
                         chatViewCotroller.askQuestionWithAI(
                          question:
                          value);
                        },
                        hintText: 'Type your message...',
                      )),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
