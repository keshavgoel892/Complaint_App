import 'package:flutter/material.dart';
import 'complaint_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedRole = 'Citizen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 76, 157, 194),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Emergency Call'),
                    content: Text('Do you want to call the police (100)?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Call'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Add actual call functionality here
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlue,//home screen background color
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: _selectedRole,
                  items: ['Citizen', 'Admin'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 18, color: Colors.blue)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  underline: Container(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  isExpanded: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Continue', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  if (_selectedRole == 'Citizen') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComplaintScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}