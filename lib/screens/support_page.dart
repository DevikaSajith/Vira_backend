import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EmergencySupportPage extends StatefulWidget {
  const EmergencySupportPage({Key? key}) : super(key: key);

  @override
  State<EmergencySupportPage> createState() => _EmergencySupportPageState();
}

class _EmergencySupportPageState extends State<EmergencySupportPage> {
  final DatabaseReference _supportRef =
      FirebaseDatabase.instance.ref().child('support');

  Map<String, dynamic> supportData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSupportData();
  }

  void fetchSupportData() async {
    try {
      final snapshot = await _supportRef.get();
      if (snapshot.exists) {
        setState(() {
          supportData = Map<String, dynamic>.from(snapshot.value as Map);
        });
      }
    } catch (e) {
      debugPrint("Error fetching support data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Support"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : supportData.isEmpty
              ? const Center(child: Text("No support data found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: supportData.length,
                  itemBuilder: (context, index) {
                    final key = supportData.keys.elementAt(index);
                    final data = Map<String, dynamic>.from(supportData[key]);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(data['name'] ?? 'Unknown'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data['number'] != null)
                              Text('📞 ${data['number']}'),
                            if (data['timing'] != null)
                              Text('🕒 ${data['timing']}'),
                            if (data['description'] != null)
                              Text(data['description']),
                            if (data['website'] != null)
                              Text('🌐 ${data['website']}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
