import 'package:flutter/material.dart';

class ScreeningForClassFormEight extends StatefulWidget {
  const ScreeningForClassFormEight({super.key});

  @override
  State<ScreeningForClassFormEight> createState() => _ScreeningForClassFormEightState();
}

class _ScreeningForClassFormEightState extends State<ScreeningForClassFormEight> {
  final TextEditingController _doctorNameController = TextEditingController();

  @override
  void dispose() {
    _doctorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Screening For 5st Class',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '8/8',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Name Label with required indicator
            Row(
              children: [
                Text(
                  'Doctor Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Text Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _doctorNameController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter doctor name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40),

            // Bottom Buttons
            Row(
              children: [
                // Previous Button
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle previous action
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F4A6A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // Submit Button
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle submit action
                        if (_doctorNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter doctor name'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }else{
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }

                        // Process form submission
                        print('Doctor Name: ${_doctorNameController.text}');

                        // You can navigate to next screen or show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Form submitted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F4A6A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Usage example - how to navigate to this screen
