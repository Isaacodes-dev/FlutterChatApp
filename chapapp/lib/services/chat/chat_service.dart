import 'package:chapapp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String recieverID, String message)async{
    //get current user
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
      senderId: currentUserId, 
      senderEmail: currentUserEmail, 
      recieverID: recieverID, 
      timestamp: timestamp, 
      message: message);

    //construct chat room id current user and reciever
    List<String> ids = [currentUserId, recieverID];
    ids.sort();
    String chatRoomId = ids.join("_");

    //add new message to database
    await _firestore.collection('chat_rooms').doc(chatRoomId)
    .collection('messages')
    .add(newMessage.toMap());
  }
  //get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){

    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore.collection('chat_rooms').doc(chatRoomId)
    .collection('messages')
    .orderBy('timestamp', descending: false)
    .snapshots();

  }
}