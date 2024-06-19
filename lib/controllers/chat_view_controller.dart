import 'package:chat_boat/helpers/api_keys.dart';
import 'package:chat_boat/helpers/services.dart';
import 'package:chat_boat/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatViewController extends GetxController {
  List<ChatModel> messages = [];
  String currentChatRoomName = '';
  final ScrollController scrollController = ScrollController();

  /// This Method will fatch all previous Messages in current chat room.
  /// [chatRoomName] This Params will be current Chat Room Name
  /// [context] This Params will be current Widget Context.
  getMessage(
      {required String chatRoomName, required BuildContext context}) async {
    print(chatRoomName);
    Services().getSavedMessage(key: chatRoomName).then((value) async {
      print(value);
      List<ChatModel> messageResult = value != null
          ? value.map((chatMap) => ChatModel.fromJson(chatMap)).toList()
          : [];
      messages = messageResult;
      update();
      autoScroll();
      if (chatRoomName.split("%20").first == 'Untitled') {
        getChatRoomName(chatRoomName: chatRoomName, context: context);
      }
    });
  }

  /// This Method Will show popup for Enter ChatRoom Name..
  /// [chatRoomName] This Params will be current Chat Room Name
  /// [context] This Params will be current Widget Context.
  getChatRoomName(
      {required String chatRoomName, required BuildContext context}) async {
    if (currentChatRoomName.split("%20").first == 'Untitled') {
      update();
      showEnterChatRoomPopup(
        currentChatRoom:
        chatRoomName,
        context:
         context);
    }
  }


///This Method will Auto Scroll The Screen when message comes or Send.
  autoScroll() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration:const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

///This Method will show popup for Enter chatroom Name.
///[currentChatRoom]  This Params will be current ChatRoom Name params.
///[context] This Params will be current Widget context.
  showEnterChatRoomPopup({required String currentChatRoom, required BuildContext context}) {
    TextEditingController _textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return alert dialog
        return AlertDialog(
          title: const Text(
            'Enter Chatroom Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Enter name here..."),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () async {
                bool result = await Services().updateChatRoomName(
                    newName: _textEditingController.text,
                    oldName: currentChatRoom);
                if (result) {
                  currentChatRoomName = _textEditingController.text +
                      "%20" +
                      currentChatRoom.split("%20").last;

                  Navigator.pop(context);
                  update();
                } else {
                  print("faild");
                }
              },
              child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green[800]),
                  alignment: Alignment.center,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        );
      },
    );
  }

///This Method will Save Your messages into Database.
  saveMessages() async {
    bool result = await Services.saveMessage(
        messages: messages, key: currentChatRoomName);
    print(result);
  }


/// This Method will ask Your Question with AI.
/// [question] This Params will be your Question which you want to ask.
  askQuestionWithAI({required String question}) async {
    messages.add(ChatModel(
        isMe: true,
        message: question,
        time: DateFormat('h:mm a').format(DateTime.now())));
    update();
    autoScroll();
    try {
      final model = GenerativeModel(
          model: 'gemini-1.5-flash', apiKey: ApiKeys.geminiApiKey);
      final content = [Content.text(question)];
      final response = await model.generateContent(content);
      messages.add(ChatModel(
          isMe: false,
          message: response.text!,
          time: DateFormat('h:mm a').format(DateTime.now())));
      update();
      saveMessages();
      autoScroll();
    } catch (e) {
      print(e);
    }
  }
}
