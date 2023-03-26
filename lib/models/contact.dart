import 'package:shared_preferences/shared_preferences.dart';

class Contact {
  final String name;
  final String ipAddress;

  Contact({required this.name, required this.ipAddress});

static Future<List<Contact>> contacts() async
{
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the 'items' key. If it doesn't exist, returns null.
    final List<String> contactNames = prefs.getStringList('contactNames') ?? [];
    final List<String> contactIps = prefs.getStringList('contactIps') ?? [];
    int size = contactNames.length;
    List<Contact> result = [];
    for (int i = 0; i < size; i++) {
      result.add(Contact(name: contactNames[i], ipAddress: contactIps[i]));
    }
    return result;
}
  static void saveContact(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the 'items' key. If it doesn't exist, returns null.
    final List<String> contactNames = [];
    final List<String> contactIps = [];
    int size = contacts.length;
    for (int i = 0; i < size; i++) {
      contactNames.add(contacts[i].name);
      contactIps.add(contacts[i].ipAddress);
    }
    await prefs.setStringList('contactNames', contactNames);
    await prefs.setStringList('contactIps', contactIps);
  }
}
