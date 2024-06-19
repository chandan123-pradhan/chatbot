import 'package:chat_boat/helpers/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class DashboardController extends GetxController{

List<String> chatRoomList = [];

///This Method will be get all Chat Room Name from Database.
 void getChatRooms() async {
    chatRoomList.clear();
    var result = await Services().getChatRooms();
    for (int i = 0; i < result.length; i++) {
      chatRoomList.add(result[i]);
    }
    update();
  }


}