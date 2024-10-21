import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ComplaintListScreen extends StatelessWidget {
  final String category;

  ComplaintListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.capitalize()} Complaints'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No complaints found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var complaint = snapshot.data!.docs[index];
              return ComplaintCard(complaint: complaint);
            },
          );
        },
      ),
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final QueryDocumentSnapshot complaint;

  ComplaintCard({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          complaint['name'] ?? 'Unknown',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Category: ${complaint['category'] ?? 'N/A'} - ${_formatTimestamp(complaint['timestamp'])}',
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Complaint ID: ${complaint.id}'),
                SizedBox(height: 8),
                Text('Email: ${complaint['email'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Complaint:'),
                Text(complaint['complaint'] ?? 'No details provided'),
                SizedBox(height: 8),
                if (complaint['imageUrl'] != null && complaint['imageUrl'].isNotEmpty)
                  Image.network(
                    complaint['imageUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 8),
                ElevatedButton(
                  child: Text('Update Status'),
                  onPressed: () => _showStatusUpdateDialog(context),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());
  }

  void _showStatusUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Complaint Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusButton(context, 'Registered'),
              _buildStatusButton(context, 'Pending'),
              _buildStatusButton(context, 'Resolved'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusButton(BuildContext context, String status) {
    return ElevatedButton(
      child: Text(status),
      onPressed: () {
        FirebaseFirestore.instance
            .collection('complaints')
            .doc(complaint.id)
            .update({'status': status.toLowerCase()})
            .then((_) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Complaint status updated to $status')),
          );
        }).catchError((error) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update status: $error')),
          );
        });
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}