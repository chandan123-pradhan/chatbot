
import 'package:chat_boat/global_variables.dart';
import 'package:chat_boat/helpers/shared_pref.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chat_boat/helpers/api_keys.dart';
import 'package:chat_boat/models/chat_model.dart';
import 'package:chat_boat/views/chat_item_widget.dart';
import 'package:chat_boat/views/chat_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  bool isNew;
  ChatView({required this.isNew});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<ChatModel> messages = [];
  String chatRoomName = '';
  String responseTxt = '';



  completionFun(String question) async {
    messages.add(ChatModel(
        isMe: true,
        message: question,
        time: DateFormat('h:mm a').format(DateTime.now())));
    setState(() {});
    try {
      final model = GenerativeModel(
          model: 'gemini-1.5-flash', apiKey: ApiKeys.geminiApiKey);
      final content = [Content.text(question)];
      final response = await model.generateContent(content);
      messages.add(ChatModel(
          isMe: false,
          message: response.text!,
          time: DateFormat('h:mm a').format(DateTime.now())));
      setState(() {});
      saveMessages();
    } catch (e) {
      print(e);
    }
  }

  getMessage() async {
    SharedPref().getSavedMessage().then((value) async {
      List<ChatModel> message = value != null
          ? value.map((chatMap) => ChatModel.fromJson(chatMap)).toList()
          : [];
      messages = message;
      getChatRoomName();
    
    });
  }

getChatRoomName()async{
  var result = await SharedPref().getChatRoomName();
      chatRoomName = result;
        setState(() {});
    showEnterChatRoomPopup();
}


showEnterChatRoomPopup(){
  if(chatRoomName==''){
    TextEditingController _textEditingController=new TextEditingController();
 showDialog(
              context: context,
              builder: (BuildContext context) {
                // Return alert dialog
                return AlertDialog(
                  title: Text(
                    'Enter Chatroom Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  content: TextField(
                    controller: _textEditingController,
                    decoration:const  InputDecoration(hintText: "Enter name here..."),
                  ),
                  actions: <Widget>[
                    InkWell(
                      onTap: ()async{
                        Navigator.pop(context);
                        bool result=await SharedPref().saveChatName(_textEditingController.text);
                        chatsList.add(_textEditingController.text);
                        if(result){
                          getChatRoomName();
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
}

  saveMessages() async {
    bool result = await SharedPref().saveMessage(messages: messages);
    print(result);
  }

  @override
  void initState() {
   if(widget.isNew){

   }else{
     getMessage();
   }
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
            child: Icon(
              Icons.navigate_before_rounded,
              size: 30,
              color: Colors.white,
            )),
        elevation: 0,
        backgroundColor: Colors.green[800],
        title: InkWell(
          onTap: () {
           showEnterChatRoomPopup();
          },
          child:  Text(
          chatRoomName==''?'Untitled':chatRoomName ,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              onTap: () {
                SharedPref().clearChat();
                messages.clear();
                chatRoomName='';
                setState(() {});
              },
              child: Text(
                "Clear Chat",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.25,
              child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: ChatItemWidget(
                        message: messages[index].message,
                        time: messages[index].time,
                        isMe: messages[index].isMe,
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
                      completionFun(value);
                    },
                    hintText: 'Type your message...',
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
