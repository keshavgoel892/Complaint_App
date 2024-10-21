import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatefulWidget {
  final String? complaintId;

  FeedbackScreen({this.complaintId});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackData = {'feedback': '', 'category': 'General'};
  List<String> _communityNews = [];

  static const List<String> categories = [
    'General',
    'App Functionality',
    'User Interface',
    'Performance',
    'Feature Request',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _fetchCommunityNews();
  }

  Future<void> _fetchCommunityNews() async {
    try {
      final newsSnapshot = await FirebaseFirestore.instance
          .collection('community_news')
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();
      
      setState(() {
        _communityNews = newsSnapshot.docs
            .map((doc) => doc['content'] as String)
            .toList();
      });
    } catch (error) {
      print('Error fetching community news: $error');
    }
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          ..._feedbackData,
          'timestamp': FieldValue.serverTimestamp(),
          'complaintId': widget.complaintId, // Add the complaint ID if available
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.complaintId != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text('Complaint ID: ${widget.complaintId}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              _buildCommunityNewsSection(),
              SizedBox(height: 20),
              _buildFeedbackForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityNewsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Community News', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _communityNews.isEmpty
                ? CircularProgressIndicator()
                : Column(
                    children: _communityNews
                        .map((news) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Text('• $news'),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Feedback'),
            maxLines: 5,
            validator: (value) => value!.isEmpty ? 'Please enter your feedback' : null,
            onSaved: (value) => _feedbackData['feedback'] = value!,
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _feedbackData['category'],
            decoration: InputDecoration(labelText: 'Category'),
            items: categories
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => setState(() => _feedbackData['category'] = value!),
            validator: (value) => value == null ? 'Please select a category' : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Submit Feedback'),
            onPressed: _submitFeedback,
          ),
        ],
      ),
    );
  }
}