import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatController.dart';
import '../models/chat.dart';
import '../models/contact.dart';

class ChatScreen extends StatefulWidget {
  final Contact contact;
  ChatScreen({required this.contact});

  @override
  State<ChatScreen> createState() => _ChatScreenState(contact: contact);
}

class _ChatScreenState extends State<ChatScreen> {
  final Contact contact;
  _ChatScreenState({required this.contact});

  ChatController chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async
  {
    await chatController.setIPs(contact.ipAddress);
    chatController.startListening();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            Text(contact.name),
            Row(
              children: [
                Icon(Icons.video_call),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.call)
              ],
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: GetX<ChatController>(
              builder: (chatcontroller) {
                return ListView.builder(
                  controller: chatcontroller.scrollController,
                  itemCount: chatcontroller.chats.length,
                  itemBuilder: (context, index) {
                    Chat chat = chatcontroller.chats[index];
                    return chat.content.isEmpty
                        ? SizedBox(
                            height: 10,
                          )
                        : Align(
                            alignment: chat.isBot
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 5),
                                child: Text(
                                  chat.content,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )));
                  },
                );
              },
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                child: TextField(
                  controller: chatController.inputTextController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    contentPadding: EdgeInsets.all(12),
                    hintText: "Message",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (chatController
                            .inputTextController.text.isNotEmpty) {
                          chatController.sendMessage();
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
