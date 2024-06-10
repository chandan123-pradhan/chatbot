import 'dart:convert';

import 'package:chat_boat/models/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  Future<bool> saveMessage({required List<ChatModel>messages})async{
    try{
       List<Map<String, dynamic>> chatMapList =
                  messages.map((chat) => chat.toJson()).toList();
      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
      sharedPreferences.setString('messages', json.encode(chatMapList));
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }


Future<List> getSavedMessage()async{
  try{
     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     var response=sharedPreferences.getString('messages');
     print(json.decode(response!));
     return json.decode(response);
  }catch(e){
    return [];
  }
}


void clearChat()async{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  sharedPreferences.remove('messages');
  sharedPreferences.remove('chatName');
}


Future<bool> saveChatName(String name)async{
try{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
sharedPreferences.setString('chatName', name);
return true;
}catch(e){
  print(e);
  return false;
}
}
Future<String> getChatRoomName()async{
try{
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
var result=sharedPreferences.getString('chatName');
return result!;
}catch(e){
  print(e);
  return '';
}
}



}