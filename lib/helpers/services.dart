import 'dart:convert';

import 'package:chat_boat/helpers/services_keys.dart';
import 'package:chat_boat/models/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  ///This Method will save your messages into Database.
  /// [messages] : This Params will be message List.
  /// [key] : This params will be end point or key of the current chat room.
  static Future<bool> saveMessage(
      {required List<ChatModel> messages, required String key}) async {
    try {
      List<Map<String, dynamic>> chatMapList =
          messages.map((chat) => chat.toJson()).toList();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(key, json.encode(chatMapList));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// This Method will be get all saved Message from database of the current chat room.
  Future<List> getSavedMessage({required String key}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var response = sharedPreferences.getString(key);
      print(json.decode(response!));
      return json.decode(response);
    } catch (e) {
      return [];
    }
  }

  /// This Method will be get all chatrooms list from datase.
  Future<List> getChatRooms() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var result = sharedPreferences.getString(ServicesKeys.chatRooms);
    print("Get chat room result=$result");
    if (result != null && result != '') {
      return result.split(',');
    } else {
      return [];
    }
  }

  /// This Method will save Chat rooms or create chat rooms.
  /// [chatName] This params will be chat room name.
  Future<bool> saveChatRoom(String chatName) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var result = await getChatRooms();
      if (result.isNotEmpty) {
        result.add(chatName);
        sharedPreferences.setString(ServicesKeys.chatRooms, result.join(','));
      } else {
        sharedPreferences.setString(ServicesKeys.chatRooms, chatName);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// This Method will delete chat room from database.
  /// [chatRoomName] This Params will be chat room name which you want to delete.
  Future<bool> deleteChatRoom(String chatRoomName) async {
    print(chatRoomName);
    List result = await getChatRooms();
    var response = result.remove(chatRoomName);
    print(response);
    if (response) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(ServicesKeys.chatRooms, result.join(','));
      return true;
    } else {
      return false;
    }
  }

  /// This Method will udpate your chat room name.
  /// [newName] This Params will be new name of the current chat room.
  /// [oldName]  This Params will be old name of the current chat Room.
  Future<bool> updateChatRoomName(
      {required String newName, required String oldName}) async {
    try {
      List result = await getChatRooms();
      for (int i = 0; i < result.length; i++) {
        if (oldName == result[i]) {
          String name = newName + "%20" + oldName.split("%20").last;
          await deleteChatRoom(oldName);
          await saveChatRoom(name);
          break;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
