import 'package:flutter/material.dart';
import 'package:school_test/screens/add_school_screen.dart';
import 'package:school_test/screens/screening_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.blue,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.50, // Makes cards taller to match the image
            children: [
              _buildCard(
                icon: Icons.computer,
                title: 'Start Screening\nFor School',
                onTap: () {
                  // Navigate to Start Screening For School
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenningSchoolScreen()));
                },
              ),
              _buildCard(
                icon: Icons.school,
                title: 'Add School',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddSchoolScreen()));
                },
              ),
              _buildCard(
                icon: Icons.computer,
                title: 'Start Screening\nFor Angan Wadi',
                onTap: () {
                  // Navigate to Start Screening For Angan Wadi
                },
              ),
              _buildCard(
                icon: Icons.school,
                title: 'Add Angan Wadi',
                onTap: () {
                  // Navigate to Add Angan Wadi
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}