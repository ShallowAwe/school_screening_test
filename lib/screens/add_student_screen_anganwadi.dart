import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart'; // Fixed import

import 'package:http/http.dart' as http;

class AddStudentScreenAnganwadi extends StatefulWidget {
  final String className;
  final int schoolId;
  final String schoolName;
  final String talukaName;
  final int talukaId;
  final String districtName;
  final int districtId;
  final String gramPanchayatName;
  final int gramPanchayatId;

  const AddStudentScreenAnganwadi({
    super.key,
    required this.className,
    required this.schoolId,
    required this.schoolName,
    required this.talukaName,
    required this.talukaId,
    required this.districtName,
    required this.districtId,
    required this.gramPanchayatName,
    required this.gramPanchayatId,
  });

  @override
  State<AddStudentScreenAnganwadi> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudentScreenAnganwadi> {
  final _formKey = GlobalKey<FormState>();
  final _logger = Logger();

  // Controllers
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController aadharCardController = TextEditingController();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController parentContactController = TextEditingController();

  DateTime? dateOfBirth;
  String? gender;
  bool _isSubmitting = false; // Added loading state

  @override
  void dispose() {
    studentNameController.dispose();
    aadharCardController.dispose();
    parentNameController.dispose();
    parentContactController.dispose();
    super.dispose();
  }

  // Fixed age calculation
  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[800]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.blue[800]!,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != dateOfBirth) {
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) return;

    if (dateOfBirth == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select date of birth')));
      return;
    }

    if (gender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select gender')));
      return;
    }

    setState(() => _isSubmitting = true);

    final age = calculateAge(dateOfBirth!);
    final normalizedClassName = widget.className
        .replaceAll(' Class', '')
        .trim();

    final Map<String, dynamic> data = {
      "schoolId": widget.schoolId,
      "talukaId": widget.talukaId,
      "talukaName": widget.talukaName,
      "districtId": widget.districtId,
      "districtName": widget.districtName,
      "gramPanchayatId": widget.gramPanchayatId,
      "gramPanchayatName": widget.gramPanchayatName,
      "anganwadi": normalizedClassName.toLowerCase() == "anganwadi",
      "miniAnganwadi": normalizedClassName.toLowerCase() == "mini anganwadi",
      "firstClass":
          normalizedClassName == "1st" || normalizedClassName == "First",
      "secondClass":
          normalizedClassName == "2nd" || normalizedClassName == "Second",
      "thirdClass":
          normalizedClassName == "3rd" || normalizedClassName == "Third",
      "fourthClass":
          normalizedClassName == "4th" || normalizedClassName == "Fourth",
      "fifthClass":
          normalizedClassName == "5th" || normalizedClassName == "Fifth",
      "sixthClass":
          normalizedClassName == "6th" || normalizedClassName == "Sixth",
      "seventhClass":
          normalizedClassName == "7th" || normalizedClassName == "Seventh",
      "eighthClass":
          normalizedClassName == "8th" || normalizedClassName == "Eighth",
      "ninthClass":
          normalizedClassName == "9th" || normalizedClassName == "Ninth",
      "tenthClass":
          normalizedClassName == "10th" || normalizedClassName == "Tenth",
      "eleventhClass":
          normalizedClassName == "11th" || normalizedClassName == "Eleventh",
      "twelfthClass":
          normalizedClassName == "12th" || normalizedClassName == "Twelfth",
      "childName": studentNameController.text.trim(),
      "age": age,
      "dateOfBirth": dateOfBirth!.toIso8601String(),
      "gender": gender,
      "aadhaarNo": aadharCardController.text.trim(),
      "fathersName": parentNameController.text.trim(),
      "fathersContactNo": parentContactController.text.trim(),
    };

    try {
      final url = Uri.parse('https://api.rbsknagpur.in/api/Rbsk/CreateStudent');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.i('Student added successfully: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Student added successfully!'),
              backgroundColor: Colors.green[700],
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        _logger.e('Failed with ${response.statusCode}: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed: ${response.reasonPhrase ?? "Unknown error"}',
              ),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      }
    } catch (e) {
      _logger.e('Exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive padding based on screen width
    final horizontalPadding = width * 0.05;
    final verticalPadding = height * 0.02;

    // Responsive spacing
    final smallSpacing = height * 0.01;
    final mediumSpacing = height * 0.02;
    final largeSpacing = height * 0.025;

    // Responsive font sizes
    final titleFontSize = width * 0.045;
    final subtitleFontSize = width * 0.035;
    final labelFontSize = width * 0.037;
    final bodyFontSize = width * 0.04;

    // Responsive border radius
    final borderRadius = width * 0.02;

    // Responsive button height
    final buttonHeight = height * 0.06;

    // Responsive icon size
    final iconSize = width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        foregroundColor:
            Colors.white, // Fixed: Changed from const Color(0xFF1a1a1a)
        title: Text(
          'Add Student',
          style: TextStyle(
            fontSize: titleFontSize.clamp(16.0, 20.0),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with school info
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(horizontalPadding),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding * 1.2,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius * 1.5),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.schoolName,
                    style: TextStyle(
                      color: const Color(0xFF1a1a1a),
                      fontSize: titleFontSize.clamp(16.0, 20.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: smallSpacing * 0.8),
                  Text(
                    'Class: ${widget.className}',
                    style: TextStyle(
                      color: const Color(0xFF757575),
                      fontSize: subtitleFontSize.clamp(13.0, 16.0),
                    ),
                  ),
                  Text(
                    'School ID: ${widget.schoolId}',
                    style: TextStyle(
                      color: const Color(0xFF9E9E9E),
                      fontSize: (subtitleFontSize * 0.9).clamp(12.0, 15.0),
                    ),
                  ),
                ],
              ),
            ),

            // Form section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: smallSpacing),

                    // Student Name
                    TextFormField(
                      controller: studentNameController,
                      enabled: !_isSubmitting,
                      style: TextStyle(
                        fontSize: bodyFontSize.clamp(14.0, 16.0),
                        color: const Color(0xFF1a1a1a),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Student Name',
                        labelStyle: TextStyle(
                          color: const Color(0xFF757575),
                          fontSize: labelFontSize.clamp(13.0, 15.0),
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: const Color(0xFF757575),
                          size: iconSize.clamp(18.0, 22.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            color: Colors.blue[800]!,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalPadding,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter student name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: mediumSpacing),

                    // Aadhar Card Number
                    TextFormField(
                      controller: aadharCardController,
                      enabled: !_isSubmitting,
                      style: TextStyle(
                        fontSize: bodyFontSize.clamp(14.0, 16.0),
                        color: const Color(0xFF1a1a1a),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Aadhar Card Number',
                        labelStyle: TextStyle(
                          color: const Color(0xFF757575),
                          fontSize: labelFontSize.clamp(13.0, 15.0),
                        ),
                        prefixIcon: Icon(
                          Icons.badge_outlined,
                          color: const Color(0xFF757575),
                          size: iconSize.clamp(18.0, 22.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            color: Colors.blue[800]!,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalPadding,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Aadhar card number';
                        }
                        if (value.length != 12) {
                          return 'Aadhar card must be 12 digits';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Aadhar card must contain only digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: mediumSpacing),

                    // Date of Birth
                    InkWell(
                      onTap: _isSubmitting ? null : () => _selectDate(context),
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalPadding * 1.1,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(borderRadius),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: const Color(0xFF757575),
                              size: iconSize.clamp(18.0, 22.0),
                            ),
                            SizedBox(width: horizontalPadding * 0.5),
                            Expanded(
                              child: Text(
                                dateOfBirth == null
                                    ? 'Select Date of Birth'
                                    : DateFormat(
                                        'dd MMM yyyy',
                                      ).format(dateOfBirth!),
                                style: TextStyle(
                                  fontSize: bodyFontSize.clamp(14.0, 16.0),
                                  color: dateOfBirth == null
                                      ? const Color(0xFF9E9E9E)
                                      : const Color(0xFF1a1a1a),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: mediumSpacing),

                    // Gender
                    Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: labelFontSize.clamp(13.0, 16.0),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1a1a1a),
                      ),
                    ),
                    SizedBox(height: smallSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _isSubmitting
                                ? null
                                : () => setState(() => gender = 'Male'),
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: verticalPadding * 0.9,
                              ),
                              decoration: BoxDecoration(
                                color: gender == 'Male'
                                    ? Colors.blue[800]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  borderRadius,
                                ),
                                border: Border.all(
                                  color: gender == 'Male'
                                      ? Colors.blue[800]!
                                      : const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    gender == 'Male'
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: gender == 'Male'
                                        ? Colors.white
                                        : const Color(0xFF9E9E9E),
                                    size: iconSize.clamp(18.0, 22.0),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.25),
                                  Text(
                                    'Male',
                                    style: TextStyle(
                                      fontSize: bodyFontSize.clamp(14.0, 16.0),
                                      fontWeight: FontWeight.w500,
                                      color: gender == 'Male'
                                          ? Colors.white
                                          : const Color(0xFF757575),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: horizontalPadding * 0.4),
                        Expanded(
                          child: InkWell(
                            onTap: _isSubmitting
                                ? null
                                : () => setState(() => gender = 'Female'),
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: verticalPadding * 0.9,
                              ),
                              decoration: BoxDecoration(
                                color: gender == 'Female'
                                    ? Colors.blue[800]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  borderRadius,
                                ),
                                border: Border.all(
                                  color: gender == 'Female'
                                      ? Colors.blue[800]!
                                      : const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    gender == 'Female'
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: gender == 'Female'
                                        ? Colors.white
                                        : const Color(0xFF9E9E9E),
                                    size: iconSize.clamp(18.0, 22.0),
                                  ),
                                  SizedBox(width: horizontalPadding * 0.25),
                                  Text(
                                    'Female',
                                    style: TextStyle(
                                      fontSize: bodyFontSize.clamp(14.0, 16.0),
                                      fontWeight: FontWeight.w500,
                                      color: gender == 'Female'
                                          ? Colors.white
                                          : const Color(0xFF757575),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mediumSpacing),

                    // Parent Name
                    TextFormField(
                      controller: parentNameController,
                      enabled: !_isSubmitting,
                      style: TextStyle(
                        fontSize: bodyFontSize.clamp(14.0, 16.0),
                        color: const Color(0xFF1a1a1a),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Parent Name',
                        labelStyle: TextStyle(
                          color: const Color(0xFF757575),
                          fontSize: labelFontSize.clamp(13.0, 15.0),
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: const Color(0xFF757575),
                          size: iconSize.clamp(18.0, 22.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            color: Colors.blue[800]!,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalPadding,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter parent name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: mediumSpacing),

                    // Parent Contact Number
                    TextFormField(
                      controller: parentContactController,

                      enabled: !_isSubmitting,
                      style: TextStyle(
                        fontSize: bodyFontSize.clamp(14.0, 16.0),
                        color: const Color(0xFF1a1a1a),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Parent Contact Number',
                        labelStyle: TextStyle(
                          color: const Color(0xFF757575),
                          fontSize: labelFontSize.clamp(13.0, 15.0),
                        ),
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: const Color(0xFF757575),
                          size: iconSize.clamp(18.0, 22.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            color: Colors.blue[800]!,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding * 0.8,
                          vertical: verticalPadding,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter parent contact number';
                        }
                        if (value.length != 10) {
                          return 'Contact number must be 10 digits';
                        }
                        if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
                          return 'Please enter a valid Indian mobile number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: largeSpacing * 1.2),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight.clamp(48.0, 56.0),
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Add Student',
                                style: TextStyle(
                                  fontSize: bodyFontSize.clamp(15.0, 17.0),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: verticalPadding * 1.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
