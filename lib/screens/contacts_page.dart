import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic> contacts = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    final snapshot = await databaseReference.child('contacts').get();
    if (snapshot.exists) {
      setState(() {
        contacts = Map<String, dynamic>.from(snapshot.value as Map);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : contacts.isEmpty
            ? const Center(child: Text('No contacts available'))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  String district = contacts.keys.elementAt(index);
                  Map<String, dynamic> districtContacts =
                      Map<String, dynamic>.from(contacts[district]);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      title: Text(
                        district,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: districtContacts.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          trailing: Text(entry.value.toString()),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
  }
}
