import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentInfoScreen extends StatefulWidget {
  final int schoolId;
  final String className;
  final int doctorId;
  final bool isSchool;

  const StudentInfoScreen({
    super.key,
    required this.schoolId,
    required this.className,
    required this.doctorId,
    required this.isSchool,
  });

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<dynamic> students = [];

  @override
  void initState() {
    super.initState();
    fetchScreenedStudents();
  }

  // Map UI class names to API class names
  String mapClassNameForApi(String className) {
    switch (className) {
      case '1st Class':
        return 'FirstClass';
      case '2nd Class':
        return 'SecondClass';
      case '3rd Class':
        return 'ThirdClass';
      case '4th Class':
        return 'FourthClass';
      case '5th Class':
        return 'FifthClass';
      case '6th Class':
        return 'SixthClass';
      case '7th Class':
        return 'SeventhClass';
      case '8th Class':
        return 'EighthClass';
      case '9th Class':
        return 'NinethClass';
      case '10th Class':
        return 'TenthClass';
      case '11th Class':
        return 'EleventhClass';
      case '12th Class':
        return 'TwelthClass';
      default:
        return className;
    }
  }

  Future<void> fetchScreenedStudents() async {
    final url =
        Uri.parse("https://api.rbsknagpur.in/api/Rbsk/GetScreenedDataBySchoolIdClass");

    final requestBody = {
      "SchoolId": widget.schoolId,
      "Class": mapClassNameForApi(widget.className),
      "doctorId": widget.doctorId,
      "IsSchool": widget.isSchool,
    };

    print("➡️ API URL: $url");
    print("➡️ Request Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      print("⬅️ Status Code: ${response.statusCode}");
      print("⬅️ Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          setState(() {
            students = decoded['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = decoded['responseMessage'] ?? "No students found.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to fetch students. Please try again.";
        isLoading = false;
      });
      print("❌ Exception while calling API: $e");
    }
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, color: Colors.blue[200], size: 60),
            const SizedBox(height: 16),
            const Text(
              "No students found in this class.",
              style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: fetchScreenedStudents,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, color: Colors.blue[200], size: 60),
            const SizedBox(height: 16),
            const Text(
              "No students found in this class.",
              style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: Text(
              student['childName'] ?? "Unknown",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Father: ${student['fathersName'] ?? ''}"),
                Text("Contact: ${student['fathersContactNo'] ?? ''}"),
              ],
            ),
            trailing: Text(
              student['createdDate']?.toString().split("T").first ?? "",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: fetchScreenedStudents,
        color: Colors.white,
        backgroundColor: Colors.blue,
        child: _buildBody(),
      ),
    );
  }
}
