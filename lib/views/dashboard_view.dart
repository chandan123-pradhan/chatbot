import 'package:chat_boat/global_variables.dart';
import 'package:chat_boat/views/chat_view.dart';
import 'package:flutter/material.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[800],
title:const  Text("Customer Support",
style: TextStyle(
  color: Colors.white,
  fontSize: 18,fontWeight: FontWeight.w600
),
),
      ),

      body: 
      
      chatsList.isEmpty?
      Center(
        child: Image.asset('assets/chat.png',
        height: 200,
        width: 200,
        ),
      ):
      
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: ListView.builder(
          itemCount: chatsList.length,
          itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context){
    return ChatView(
      isNew: false,
    );
  })).then((value) {
    setState(() {
      
    });
  });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: .5,color: Colors.black)
                ),
                height: 40,
                width: MediaQuery.of(context).size.width/1,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Text(chatsList[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                  ),
                ),
              ),
            ),
          );
        }),
      )
      ,

floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.green[800],
  child: Image.asset('assets/chatbot.png',
  height: 40,
  width: 40,
  ),
  onPressed: (){
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return ChatView(
      isNew: true,
    );
  })).then((value) {
    setState(() {
      
    });
  });
  
}),






    );
  }
}