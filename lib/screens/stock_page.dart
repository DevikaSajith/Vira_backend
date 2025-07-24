import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:provider/provider.dart'; // Import provider
import 'dart:async'; // For StreamSubscription

import '../theme_provider.dart'; // Import your theme provider

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final _dbRef = FirebaseDatabase.instance.ref('stock_items');
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();

  // New state for the toggle button
  bool _showLowStockOnly = false; // Renamed for clarity: show items with quantity <= 5

  // To manage the Firebase stream subscription and prevent duplicates
  StreamSubscription<DatabaseEvent>? _stockSubscription;
  List<StockItem> _stockItems = []; // List to hold fetched and filtered stock items
  bool _isLoading = true; // To manage loading state

  @override
  void initState() {
    super.initState();
    _listenToStockChanges(); // Start listening to Firebase changes
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _stockSubscription?.cancel(); // Crucial: Cancel the Firebase stream subscription
    super.dispose();
  }

  // Method to listen for real-time changes from Firebase
  void _listenToStockChanges() {
    _stockSubscription = _dbRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists && dataSnapshot.value is Map) {
        final Map<dynamic, dynamic> itemsMap = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        List<StockItem> fetchedList = [];
        itemsMap.forEach((key, value) {
          if (value is Map) {
            fetchedList.add(StockItem.fromMap(key, Map<String, dynamic>.from(value)));
          }
        });
        setState(() {
          _stockItems = fetchedList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _stockItems = [];
          _isLoading = false;
        });
      }
    }, onError: (error) {
      print('Firebase error: $error');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading stock: $error')),
      );
    });
  }

  // Method to add new stock item
  void _addStockItem() {
    final name = _itemNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (name.isNotEmpty && quantity > 0) {
      _dbRef.push().set({
        'name': name,
        'quantity': quantity,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stock item "$name" added!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add stock item: $error')),
        );
      });
      _itemNameController.clear();
      _quantityController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid item name and quantity.')),
      );
    }
  }

  // Method to edit stock item quantity
  void _editStockItem(String key, Map<String, dynamic> currentItem) {
    final TextEditingController editQuantityController =
        TextEditingController(text: currentItem['quantity'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Quantity for ${currentItem['name']}'),
          content: TextField(
            controller: editQuantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'New Quantity',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newQuantity = int.tryParse(editQuantityController.text.trim()) ?? 0;
                if (newQuantity >= 0) {
                  _dbRef.child(key).update({
                    'quantity': newQuantity,
                  }).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Quantity for "${currentItem['name']}" updated to $newQuantity.')),
                    );
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update quantity: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid non-negative quantity.')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to filter stocks based on the toggle state
  List<StockItem> _getFilteredStocks() {
    if (_showLowStockOnly) {
      return _stockItems.where((item) => item.quantity <= 5).toList(); // Define "low stock" threshold
    }
    return _stockItems;
  }

  @override
  Widget build(BuildContext context) {
    // Access theme provider for theme-aware colors and styles
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    // Theme-aware colors and styles (kept for consistency with your original code)
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final subtitleColor = Theme.of(context).textTheme.bodySmall?.color;
    final hintColor = Theme.of(context).hintColor;
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;
    final errorColor = Theme.of(context).colorScheme.error;

    // Get filtered list for display
    final filteredStocks = _getFilteredStocks();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Ensure background matches theme
      child: Column(
        children: [
          // REMOVED THE CUSTOM HEADER HERE.
          // The main.dart's HomePage AppBar handles the "Stock" title and theme toggle.

          // Toggle switch for filtering low stock items
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0), // Added top padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Show Low Stock (<= 5)', // Updated label
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                Switch(
                  value: _showLowStockOnly,
                  onChanged: (bool newValue) {
                    setState(() {
                      _showLowStockOnly = newValue;
                    });
                  },
                  activeColor: primaryColor, // Customize switch color
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : filteredStocks.isEmpty
                    ? Center(
                        child: Text(
                          _showLowStockOnly
                              ? 'No low stock items found.'
                              : 'No stock items yet.',
                          style: GoogleFonts.inter(color: subtitleColor),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: filteredStocks.length,
                        itemBuilder: (context, index) {
                          final stockItem = filteredStocks[index];
                          final key = stockItem.key; // Get the key from StockItem
                          final itemName = stockItem.name;
                          final quantity = stockItem.quantity;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                            color: cardColor,
                            elevation: isLightMode ? 2 : 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () => _editStockItem(key, { // Pass the original map or reconstruct
                                'name': itemName,
                                'quantity': quantity,
                              }),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemName,
                                            style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Quantity: $quantity',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: subtitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: errorColor),
                                      onPressed: () => _dbRef.child(key).remove().then((_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Item "$itemName" removed.')),
                                        );
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to remove item: $error')),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          // Input Section (Add new stock item) - This section remains largely the same
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isLightMode ? 0.05 : 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _itemNameController,
                  style: GoogleFonts.inter(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: GoogleFonts.inter(color: hintColor),
                    hintText: 'e.g., Pads',
                    hintStyle: GoogleFonts.inter(color: hintColor.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: hintColor.withOpacity(0.7)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _quantityController,
                  style: GoogleFonts.inter(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: GoogleFonts.inter(color: hintColor),
                    hintStyle: GoogleFonts.inter(color: hintColor.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: hintColor.withOpacity(0.7)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addStockItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Add Stock Item',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLightMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class to model your stock data, including the key
class StockItem {
  final String key; // Add key to identify item in Firebase
  final String name;
  final int quantity;

  StockItem({required this.key, required this.name, required this.quantity});

  factory StockItem.fromMap(String key, Map<String, dynamic> data) {
    return StockItem(
      key: key,
      name: data['name'] ?? 'Unnamed Item',
      quantity: data['quantity'] ?? 0,
    );
  }
}