import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String recieverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.recieverID,
    required this.timestamp,
    required this.message
  });

  Map<String, dynamic> toMap(){
    return{
      'senderId': senderId,
      'senderEmail': senderEmail,
      'recieverId': recieverID,
      'message': message,
      'timestamp':timestamp, 
    };
  }
}