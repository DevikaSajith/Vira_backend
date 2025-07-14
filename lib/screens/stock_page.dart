import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final _dbRef = FirebaseDatabase.instance.ref('stock_items');
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Stock')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _dbRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final itemsMap = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  final itemsList = itemsMap.entries.toList();

                  return ListView.builder(
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      final key = itemsList[index].key;
                      final value = Map<String, dynamic>.from(itemsList[index].value);
                      return ListTile(
                        title: Text(value['name']),
                        subtitle: Text('Quantity: ${value['quantity']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _dbRef.child(key).remove(),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No stock items yet.'));
                }
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addStockItem,
                  child: const Text('Add Stock Item'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addStockItem() {
    final name = _itemNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (name.isNotEmpty && quantity > 0) {
      _dbRef.push().set({
        'name': name,
        'quantity': quantity,
      });
      _itemNameController.clear();
      _quantityController.clear();
    }
  }
}
