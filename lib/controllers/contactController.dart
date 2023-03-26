import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import 'package:flutter/material.dart';

class ContactController extends GetxController {
  var contacts = <Contact>[].obs;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController ipTextController = TextEditingController();
  String? nameErrorHint;
  String? ipErrorHint;

  @override
  void onInit() {
    super.onInit();
    loadContacts();
  }

  void loadContacts() async {
    contacts.value = await Contact.contacts();
  }

  bool saveContact()
  {
    if (nameTextController.text.isEmpty ||
        ipTextController.text.isEmpty ||
        !validator.ip(
            ipTextController.text.trim())) {
      if(nameTextController.text.isEmpty)
        nameErrorHint = "Required";
      if(ipTextController.text.isEmpty) {
        ipErrorHint = "Required";
        return false;
      }

      if(!validator.ip(
          ipTextController.text.trim()))
        ipErrorHint = "incorrect";

      return false;
    }

    contacts.add(Contact(
        name: nameTextController.text.trim(),
        ipAddress:
        ipTextController.text.trim()));
    Contact.saveContact(contacts);
    nameTextController.clear();
    ipTextController.clear();
    return true;
  }
}
