import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:io';
import '../models/chat.dart';

class ChatController extends GetxController
{
  TextEditingController inputTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  var chats = <Chat>[Chat(content: "")].obs;
  late String hostIp;
  late String destinationIp;

  setIPs(String ip) async
  {
    destinationIp = ip;
    hostIp = await NetworkInfo().getWifiIP() ?? "";
  }


  void startListening()
  {
    // print("Listining to $hostIp");
    RawDatagramSocket.bind(InternetAddress.tryParse(hostIp), 4444).then((RawDatagramSocket socket){
      socket.listen((RawSocketEvent e){
        Datagram? d = socket.receive();
        if (d == null) return;
        String message = new String.fromCharCodes(d.data).trim();
        chats.add(Chat(content: message,isBot: true));
      });
    });
  }

  void sendMessage()
  {
    String message =
        inputTextController.text;
    chats.add(Chat(content: message));
    inputTextController.clear();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
    // print("sending from $hostIp to $destinationIp");
    RawDatagramSocket.bind(InternetAddress.tryParse(hostIp), 0).then((RawDatagramSocket socket){
      int port = 4444;
      socket.send('${message}'.codeUnits,
          InternetAddress.tryParse(destinationIp)!, port);
    });
  }
}