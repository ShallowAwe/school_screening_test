import 'package:flutter/material.dart';
import 'package:school_test/screens/add_school_screen.dart';
import 'package:school_test/screens/anganWadi_screening-forms/anganwadi_screening_form1.dart';
import 'package:school_test/screens/screening_sccreen_angnwadi.dart';
import 'package:school_test/screens/screening_screen_school.dart';
import 'package:school_test/screens/select_angan_wadi_screen.dart';

class HomeScreen extends StatefulWidget {
  int  userId;
   HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  int  userId = widgetQ.userId;
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
            childAspectRatio: 0.60, // Makes cards taller to match the image
            children: [
              _buildCard(
                icon: Icons.computer,
                title: 'Start Screening\nFor School',
                onTap: () {
                  // Navigate to Start Screening For School
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ScreenningSchoolScreen(userid: widget.userId ,)));
                },
              ),
              _buildCard(
                icon: Icons.school,
                title: 'Add School',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddSchoolScreen(userId: widget.userId  ,)));
                },
              ),
              _buildCard(
                icon: Icons.computer,
                title: 'Start Screening\nFor Angan Wadi',
                onTap: () {
                  // Navigate to Start Screening For Angan Wadi
                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScreenningAngnwadiScreen(  userid: widget.userId,)));
                },
              ),
              _buildCard(
                icon: Icons.school,
                title: 'Add Angan Wadi',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddAnganWadiScreen()));
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