import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final void Function()? onTap;
  final void Function()? onDeletePressed;
  ContactCard({required this.contact,required this.onTap,required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              contact.name[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(contact.name),
        trailing: IconButton(
          icon: Icon(Icons.delete,color: Colors.red,),
          onPressed: onDeletePressed,
        ),
      ),
    );
  }
}
