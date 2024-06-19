import 'package:flutter/material.dart';

class ChatItemWidget extends StatefulWidget {
  String message;
  String time;
  bool isMe;
   ChatItemWidget({required this.message,required this.time,required this.isMe});

  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      widget.isMe?MainAxisAlignment.end:
       MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          width: MediaQuery.of(context).size.width/1.5,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
          widget.message,
          
                style: TextStyle(
                  color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500
                ),
                
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(widget.time,style: TextStyle(
                      color: Colors.black,fontSize: 10,fontWeight: FontWeight.w400
                    ),)
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}