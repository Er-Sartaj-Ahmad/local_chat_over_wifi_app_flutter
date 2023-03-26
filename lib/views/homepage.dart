import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:networking/views/chatScreen.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../controllers/contactController.dart';
import '../models/contact.dart';
import '../widgets/contactCard.dart';

class HomePage extends StatelessWidget {
  ContactController contactController = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          contactController.ipTextController.clear();
          contactController.nameTextController.clear();
          contactController.ipErrorHint = null;
          contactController.nameErrorHint = null;
          await openDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [
        Expanded(child: GetX<ContactController>(
          builder: (contactController) {
            return ListView.builder(
              itemCount: contactController.contacts.length,
              itemBuilder: (context, index) {
                Contact cntct = contactController.contacts[index];
                return ContactCard(
                  contact: cntct,
                  onTap: () {
                    Get.to(() => ChatScreen(
                          contact: cntct,
                        ));
                  },
                  onDeletePressed: () {
                    contactController.contacts.remove(cntct);
                    contactController.saveContact();
                  },
                );
              },
            );
          },
        ))
      ]),
    );
  }

  Future openDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Center(child: Text('Add New Contact')),
                content: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: contactController.nameTextController,
                        onChanged: (v) {
                          if(v.trim().isEmpty)
                            contactController.nameErrorHint = "Required";
                          else
                            contactController.nameErrorHint = null;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Type Name',
                          errorText: contactController.nameErrorHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: contactController.ipTextController,
                        onChanged: (v) {
                          if(v.trim().isEmpty)
                              contactController.ipErrorHint = "Required";
                          else if(!validator.ip(v.trim()))
                            contactController.ipErrorHint = "Incorrect";

                          else
                            contactController.ipErrorHint = null;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelText: 'Ip Address',
                          hintText: 'Type Ip Address',
                          errorText: contactController.ipErrorHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Exit")),
                  TextButton(
                      onPressed: () {
                        if(contactController.saveContact())
                            Navigator.pop(context);
                        else
                          setState(() {});
                      },
                      child: Text("Save"))
                ],
              ),
            ));
  }
}
