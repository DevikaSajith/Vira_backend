import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:provider/provider.dart'; // Import provider

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

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addStockItem() {
    final name = _itemNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (name.isNotEmpty && quantity > 0) {
      _dbRef.push().set({
        'name': name,
        'quantity': quantity,
      }).then((_) {
        // Optional: Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stock item "$name" added!')),
        );
      }).catchError((error) {
        // Optional: Show an error message
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access theme provider
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    // Theme-aware colors and styles
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final subtitleColor = Theme.of(context).textTheme.bodySmall?.color;
    final hintColor = Theme.of(context).hintColor;
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;
    final errorColor = Theme.of(context).colorScheme.error;

    return Container( // Changed from Scaffold to Container to be a child of HomePage's Scaffold
      color: Theme.of(context).scaffoldBackgroundColor, // Ensure background matches theme
      child: Column(
        children: [
          // Custom Header mimicking AppBar
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0), // Top padding for status bar
            color: Theme.of(context).scaffoldBackgroundColor, // Blend with background
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock', // Main title as seen in image_a7dd19.png
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage Stock', // Subtitle as seen in image_a7dd19.png
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
                // Theme Toggle Button (Sun/Moon)
                IconButton(
                  icon: Icon(
                    themeProvider.themeMode == ThemeMode.light
                        ? Icons.wb_sunny
                        : Icons.mode_night,
                    color: Theme.of(context).appBarTheme.iconTheme?.color,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _dbRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: primaryColor));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: GoogleFonts.inter(color: errorColor)));
                }
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  final itemsMap = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                  final itemsList = itemsMap.entries.toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding around the list
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      final key = itemsList[index].key;
                      final value = Map<String, dynamic>.from(itemsList[index].value);
                      final itemName = value['name'] as String? ?? 'Unnamed Item';
                      final quantity = value['quantity']?.toString() ?? 'N/A';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0), // No horizontal margin
                        color: cardColor, // Card background color
                        elevation: isLightMode ? 2 : 5, // Adjust elevation based on theme
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Slightly rounded corners
                        ),
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
                                    const SizedBox(height: 4), // Reduced vertical spacing
                                    Text(
                                      'Quantity: $quantity',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: subtitleColor, // Use a more subtle color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: errorColor), // Use theme error color
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
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Text(
                    'No stock items yet.',
                    style: GoogleFonts.inter(color: subtitleColor),
                  ));
                }
              },
            ),
          ),
          // Input Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor, // Background for the input section
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isLightMode ? 0.05 : 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -5), // Shadow at the top
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
                    hintText: 'e.g., Pads', // Added hint text
                    hintStyle: GoogleFonts.inter(color: hintColor.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder( // Changed to UnderlineInputBorder
                      borderSide: BorderSide(color: hintColor.withOpacity(0.7)), // Muted line
                    ),
                    focusedBorder: UnderlineInputBorder( // Changed to UnderlineInputBorder
                      borderSide: BorderSide(color: primaryColor, width: 2.0), // Accent line on focus
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0), // Reduced vertical padding
                  ),
                ),
                const SizedBox(height: 16), // Increased spacing between fields
                TextField(
                  controller: _quantityController,
                  style: GoogleFonts.inter(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: GoogleFonts.inter(color: hintColor),
                    hintText: 'e.g., 50', // Added hint text
                    hintStyle: GoogleFonts.inter(color: hintColor.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder( // Changed to UnderlineInputBorder
                      borderSide: BorderSide(color: hintColor.withOpacity(0.7)),
                    ),
                    focusedBorder: UnderlineInputBorder( // Changed to UnderlineInputBorder
                      borderSide: BorderSide(color: primaryColor, width: 2.0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0), // Reduced vertical padding
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24), // Increased spacing before button
                SizedBox(
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                    onPressed: _addStockItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Use theme primary color
                      padding: const EdgeInsets.symmetric(vertical: 14), // Adjusted padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Slightly less rounded corners
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Add Stock Item',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLightMode ? Colors.white : Colors.black87, // Text color contrasts with primary
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