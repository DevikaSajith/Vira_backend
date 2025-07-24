import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Use Firebase Realtime Database
import 'package:google_fonts/google_fonts.dart'; // For consistent typography
import 'package:intl/intl.dart'; // For date/time formatting
import 'package:url_launcher/url_launcher.dart'; // For opening map links (if GPS is added later)

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // Reference to the 'messages' path in Firebase Realtime Database
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref('messages');

  // Function to update message status to 'delivered'
  Future<void> _markAsDelivered(String messageKey) async {
    try {
      await _messagesRef.child(messageKey).update({'status': 'delivered'});
      if (mounted) { // Check if widget is still in the tree before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message marked as delivered!', style: GoogleFonts.inter()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) { // Check if widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark message as delivered: $e', style: GoogleFonts.inter()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to delete a message
  Future<void> _deleteMessage(String messageKey) async {
    // Show a confirmation dialog before deleting
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete', style: GoogleFonts.inter()),
          content: Text('Are you sure you want to delete this message?', style: GoogleFonts.inter()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: GoogleFonts.inter(color: Theme.of(context).primaryColor)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete', style: GoogleFonts.inter(color: Colors.white)),
            ),
          ],
        );
      },
    ) ?? false; // Default to false if dialog is dismissed

    if (!confirmDelete) {
      return; // If user cancels, do nothing
    }

    try {
      await _messagesRef.child(messageKey).remove(); // Use .remove() for Realtime Database deletion
      if (mounted) { // Check if widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message deleted successfully!', style: GoogleFonts.inter()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) { // Check if widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete message: $e', style: GoogleFonts.inter()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper to format timestamp (now handles your specific String timestamps)
  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    DateTime dateTime;
    if (timestamp is int) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is String) {
      try {
        // NEW: Match the exact format "YYYY-MM-DD HH:MM:SS IST"
        // 'IST' is treated as a literal string in the format.
        dateTime = DateFormat("yyyy-MM-dd HH:mm:ss 'IST'").parse(timestamp);
      } catch (e) {
        // Fallback if parsing fails, try ISO 8601 or just return the string
        try {
          dateTime = DateTime.parse(timestamp); // Try parsing as ISO 8601
        } catch (e2) {
          print("Error parsing timestamp string: $timestamp, Error: $e2");
          return timestamp; // Return original string if parsing fails
        }
      }
    } else {
      return 'N/A'; // Handle other unexpected types
    }
    return DateFormat('MMM d, hh:mm a').format(dateTime); // e.g., "Jul 22, 01:19 AM"
  }

  // Helper to format time ago (now handles your specific String timestamps)
  String _timeAgo(dynamic timestamp) {
    if (timestamp == null) return 'N/A';

    DateTime messageTime;
    if (timestamp is int) {
      messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is String) {
      try {
        // NEW: Match the exact format "YYYY-MM-DD HH:MM:SS IST"
        messageTime = DateFormat("yyyy-MM-dd HH:mm:ss 'IST'").parse(timestamp);
      } catch (e) {
        try {
          messageTime = DateTime.parse(timestamp);
        } catch (e2) {
          print("Error parsing timestamp string for timeAgo: $timestamp, Error: $e2");
          return 'N/A';
        }
      }
    } else {
      return 'N/A';
    }

    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }

  // Optional: Function to launch a map application (if GPS coordinates are added later)
  Future<void> _launchMap(double lat, double lng) async {
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch map for $lat, $lng', style: GoogleFonts.inter())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLightMode = theme.brightness == Brightness.light;
    final textColor = theme.textTheme.bodyLarge?.color;
    final cardColor = theme.cardColor;

    return Container(
      decoration: BoxDecoration(
        gradient: isLightMode
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF7FC), // Very light pink/white at the top
                  Color(0xFFF9E7F6), // Slightly darker pink/purple in the middle
                  Color(0xFFF5E0F0), // Even darker at the bottom
                ],
                stops: [0.0, 0.5, 1.0],
              )
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2C1917), // Darker brown at top
                  Color(0xFF38201E), // Mid brown
                  Color(0xFF422B29), // Lighter brown at bottom
                ],
                stops: [0.0, 0.5, 1.0],
              ),
      ),
      child: StreamBuilder<DatabaseEvent>(
        // Listen to changes in the 'messages' path
        stream: _messagesRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading messages: ${snapshot.error}',
                style: GoogleFonts.inter(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text(
                'No messages yet.',
                style: GoogleFonts.inter(color: textColor?.withOpacity(0.7)),
              ),
            );
          }

          // Data from Realtime Database comes as a Map
          final Map<dynamic, dynamic> messagesMap =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          // Convert to a list of entries and sort by timestamp
          final messages = messagesMap.entries.toList()
            ..sort((a, b) {
              final aTimestampRaw = a.value['received_timestamp']; // Use 'received_timestamp'
              final bTimestampRaw = b.value['received_timestamp']; // Use 'received_timestamp'

              DateTime? dateTimeA;
              DateTime? dateTimeB;

              try {
                if (aTimestampRaw is String) {
                  dateTimeA = DateFormat("yyyy-MM-dd HH:mm:ss 'IST'").parse(aTimestampRaw);
                } else if (aTimestampRaw is int) { // Keep int parsing as a fallback
                  dateTimeA = DateTime.fromMillisecondsSinceEpoch(aTimestampRaw);
                }
              } catch (e) {
                print("Error parsing aTimestamp for sorting: $aTimestampRaw, Error: $e");
              }

              try {
                if (bTimestampRaw is String) {
                  dateTimeB = DateFormat("yyyy-MM-dd HH:mm:ss 'IST'").parse(bTimestampRaw);
                } else if (bTimestampRaw is int) { // Keep int parsing as a fallback
                  dateTimeB = DateTime.fromMillisecondsSinceEpoch(bTimestampRaw);
                }
              } catch (e) {
                print("Error parsing bTimestamp for sorting: $bTimestampRaw, Error: $e");
              }

              if (dateTimeA == null && dateTimeB == null) return 0;
              if (dateTimeA == null) return 1;
              if (dateTimeB == null) return -1;

              return dateTimeB.compareTo(dateTimeA); // Sort descending (latest first)
            });

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final messageEntry = messages[index];
              final messageKey = messageEntry.key as String; // Key is the message ID
              final messageData = messageEntry.value as Map<dynamic, dynamic>;

              // NEW: Extract specific fields from Firebase data
              final deviceId = messageData['device_id'] ?? 'N/A';
              final messageContent = messageData['message_content'] ?? 'No content';
              final messageTypeText = messageData['message_type_text'] ?? 'N/A';
              final receivedTimestamp = messageData['received_timestamp']; // This is the string timestamp

              // Status field is not in your screenshot data, so we'll default it or infer
              // For now, let's assume 'status' can be added later or is always 'pending'
              final status = messageData['status'] ?? 'pending'; // Assuming 'status' will be added later

              // Optional: GPS coordinates if you add them to ESP32 later
              final latitude = messageData['latitude'] as double?;
              final longitude = messageData['longitude'] as double?;

              IconData statusIcon;
              Color statusIconColor;
              Color statusTextColor;

              if (status == 'delivered') {
                statusIcon = Icons.check_circle;
                statusIconColor = Colors.green;
                statusTextColor = Colors.green;
              } else {
                statusIcon = Icons.info_outline;
                statusIconColor = Colors.orange;
                statusTextColor = Colors.orange;
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: Icon(Icons.message, color: theme.primaryColor, size: 30),
                  title: Text(
                    // Display message content and type
                    '$messageContent (${messageTypeText})',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device ID: $deviceId', // Display device ID
                        style: GoogleFonts.inter(
                          color: textColor?.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                      if (receivedTimestamp != null)
                        Text(
                          'Time: ${_formatTimestamp(receivedTimestamp)} (${_timeAgo(receivedTimestamp)})', // Display formatted time and time ago
                          style: GoogleFonts.inter(
                            color: textColor?.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      // Optional: Display and make location clickable if GPS is integrated
                      if (latitude != null && longitude != null && latitude != 0.0 && longitude != 0.0)
                        GestureDetector(
                          onTap: () => _launchMap(latitude, longitude),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: theme.primaryColor),
                                const SizedBox(width: 5),
                                Text(
                                  'Location: Lat ${latitude.toStringAsFixed(4)}, Lng ${longitude.toStringAsFixed(4)}',
                                  style: GoogleFonts.inter(
                                    color: theme.primaryColor,
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (latitude != null && latitude == 0.0 && longitude == 0.0)
                        Text(
                          'Location: No GPS fix (0,0)',
                          style: GoogleFonts.inter(
                            color: textColor?.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        )
                      else if (latitude is String && latitude == "N/A")
                        Text(
                          'Location: No GPS fix',
                          style: GoogleFonts.inter(
                            color: textColor?.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      Row(
                        children: [
                          Icon(statusIcon, size: 16, color: statusIconColor),
                          const SizedBox(width: 5),
                          Text(
                            'Status: ${status.toUpperCase()}',
                            style: GoogleFonts.inter(
                              color: statusTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delivered') {
                        _markAsDelivered(messageKey);
                      } else if (value == 'delete') {
                        _deleteMessage(messageKey);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delivered',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Mark as Delivered', style: GoogleFonts.inter()),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete Message', style: GoogleFonts.inter()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
