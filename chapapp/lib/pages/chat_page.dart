import 'package:chapapp/components/my_text_field.dart';
import 'package:chapapp/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieveUserEmail;
  final String recieveUserID;

  const ChatPage({super.key, 
  required this.recieveUserEmail,
  required this.recieveUserID 
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chartService = ChatService();
  final FirebaseAuth _firebaseAuth =  FirebaseAuth.instance;


  void sendMessage() async{
    if(_messageController.text.isNotEmpty){
      await _chartService.sendMessage(
        widget.recieveUserID, 
        _messageController.text);
        _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text(widget.recieveUserEmail)),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),

          _buildMessageInput(),
        ]
      ),
    );
  }
  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chartService.getMessages(widget.recieveUserID, 
      _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs.map((document) => _buidMessageItem(document)).toList(),
        );
      },
      );
  }
  //build message item
  Widget _buidMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the ,essages to the right if the sender is current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? 
    Alignment.centerRight : Alignment.centerLeft; 

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            Text(data['message'])
          ]
          ),
      ),
    );

  }
  //build message input
  Widget _buildMessageInput(){
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: 'Enter Message',
            obscureText: false,
          ),
        ),

        IconButton(
          onPressed: sendMessage, 
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          )
          
        )
      ],
      
    );
  }
}