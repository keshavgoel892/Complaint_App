import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'complaint_list_screen.dart';

class AdminScreen extends StatelessWidget {
  final int registeredComplaints = 16;
  final int pendingComplaints = 10;
  final int resolvedComplaints = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDashboardChart(),
              SizedBox(height: 20),
              _buildDashboardButton(
                context,
                'Registered Complaints',
                Icons.list_alt,
                Colors.blue,
                () => _navigateToComplaintList(context, 'registered'),
              ),
              SizedBox(height: 20),
              _buildDashboardButton(
                context,
                'Pending Complaints',
                Icons.pending_actions,
                Colors.orange,
                () => _navigateToComplaintList(context, 'pending'),
              ),
              SizedBox(height: 20),
              _buildDashboardButton(
                context,
                'Resolved Complaints',
                Icons.check_circle_outline,
                Colors.green,
                () => _navigateToComplaintList(context, 'resolved'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardChart() {
    return Container(
      height: 200,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Colors.blue,
                        value: registeredComplaints.toDouble(),
                        title: 'Registered',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.orange,
                        value: pendingComplaints.toDouble(),
                        title: 'Pending',
                        radius: 50,
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                          color: Colors.green,
                          value: resolvedComplaints.toDouble(),
                          title: 'Resolved',
                          radius: 50,
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(
                      'Registered', Colors.blue, registeredComplaints),
                  SizedBox(height: 8),
                  _buildLegendItem('Pending', Colors.orange, pendingComplaints),
                  SizedBox(
                    height: 8,
                  ),
                  _buildLegendItem(
                      'Resolved', Colors.green, resolvedComplaints),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int value) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text('$label: $value'),
      ],
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title,
      IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
    );
  }

  void _navigateToComplaintList(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintListScreen(category: category),
      ),
    );
  }
}
