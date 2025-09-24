import 'package:flutter/material.dart';
import 'package:school_test/screens/anganWadi_screening-forms/anganwadi_form7.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form7.dart';

class ScreeningForAngnwadiFormSix extends StatefulWidget {
  const ScreeningForAngnwadiFormSix({super.key});

  @override
  State<ScreeningForAngnwadiFormSix> createState() => _ScreeningForAngnwadiFormSixState();
}

class _ScreeningForAngnwadiFormSixState extends State<ScreeningForAngnwadiFormSix> {
 Map<String, bool> diseases = {
    'Disability': false,
  };

  // Treatment options for each disease (true = treated, false = refer)
  Map<String, bool> treatmentOptions = {};
  Map<String, String> referralOptions = {};
  Map<String, TextEditingController> treatmentNoteControllers = {};

  // Referral dropdown options
  List<String> referralList = [
    'RH',
    'SDH',
    'DH',
    'GMC',
    'IGMC',
    'MJMJY & MOUY',
    'DEIC',
    'Samaj Kalyan Nagpur',
  ];

  // No/Yes selection state
  bool hasNoDiseases = true;
  bool hasYesDiseases = false;

  @override
  void initState() {
    super.initState();
    // Initialize with "No" selected
    hasNoDiseases = true;
    hasYesDiseases = false;
    // Clear all disease selections when starting with No
    diseases.updateAll((key, value) => false);

    // Initialize treatment options and controllers for each disease
    diseases.keys.forEach((disease) {
      treatmentOptions[disease] = true; // Default to "Treated"
      referralOptions[disease] = '';
      treatmentNoteControllers[disease] = TextEditingController();
    });
  }

  void _showReferralPopup(String diseaseKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Referral options
                ...referralList.asMap().entries.map((entry) {
                  int index = entry.key;
                  String referral = entry.value;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            referralOptions[diseaseKey] = referral;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Text(
                            '${index + 1}. $referral',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      if (index < referralList.length - 1)
                        Divider(height: 1, color: Colors.grey[300]),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF2196F3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Screening For Angnwadi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '6/7',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'F. Disability',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Text('No', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hasNoDiseases = true;
                          hasYesDiseases = false;
                          // Clear all disease selections when No is selected
                          diseases.updateAll((key, value) => false);
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: hasNoDiseases
                              ? Color(0xFF2196F3)
                              : Colors.transparent,
                          border: Border.all(
                            color:
                                hasNoDiseases ? Color(0xFF2196F3) : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: hasNoDiseases
                            ? Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text('Yes', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          hasNoDiseases = false;
                          hasYesDiseases = true;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: hasYesDiseases
                              ? Color(0xFF2196F3)
                              : Colors.transparent,
                          border: Border.all(
                            color: hasYesDiseases
                                ? Color(0xFF2196F3)
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: hasYesDiseases
                            ? Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),

            // Show disease list only if "Yes" is selected
            if (hasYesDiseases) ...[
              // Disease List
              ...diseases.entries.toList().asMap().entries.map((entry) {
                int index = entry.key;
                MapEntry<String, bool> disease = entry.value;
                String diseaseKey = disease.key;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}. ${disease.key}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              diseases[disease.key] = !disease.value;
                              if (!disease.value) {
                                // Reset treatment options when disease is deselected
                                treatmentOptions[diseaseKey] = true;
                                referralOptions[diseaseKey] = '';
                                treatmentNoteControllers[diseaseKey]?.clear();
                              }
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: disease.value
                                  ? Color(0xFF2196F3)
                                  : Colors.transparent,
                              border: Border.all(
                                color: disease.value
                                    ? Color(0xFF2196F3)
                                    : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: disease.value
                                ? Icon(Icons.check,
                                    color: Colors.white, size: 18)
                                : null,
                          ),
                        ),
                      ],
                    ),

                    // Treatment options for each disease when selected
                    if (disease.value) ...[
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Treated', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      treatmentOptions[diseaseKey] = true;
                                      referralOptions[diseaseKey] = '';
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: treatmentOptions[diseaseKey]!
                                          ? Color(0xFF2196F3)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: treatmentOptions[diseaseKey]!
                                            ? Color(0xFF2196F3)
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: treatmentOptions[diseaseKey]!
                                        ? Icon(Icons.check,
                                            color: Colors.white, size: 14)
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 24),
                                Text('Refer', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      treatmentOptions[diseaseKey] = false;
                                    });
                                    _showReferralPopup(diseaseKey);
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: !treatmentOptions[diseaseKey]!
                                          ? Color(0xFF2196F3)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: !treatmentOptions[diseaseKey]!
                                            ? Color(0xFF2196F3)
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: !treatmentOptions[diseaseKey]!
                                        ? Icon(Icons.check,
                                            color: Colors.white, size: 14)
                                        : null,
                                  ),
                                ),
                                // Show selected referral value next to the checkbox
                                if (!treatmentOptions[diseaseKey]! &&
                                    referralOptions[diseaseKey]!
                                        .isNotEmpty) ...[
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF2196F3).withOpacity(0.1),
                                        border: Border.all(
                                          color: Color(0xFF2196F3),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        referralOptions[diseaseKey]!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF2196F3),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Enter Treated Note',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 60,
                              child: TextField(
                                controller:
                                    treatmentNoteControllers[diseaseKey],
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                    ] else ...[
                      SizedBox(height: 16),
                    ],
                  ],
                );
              }).toList(),
            ],

            SizedBox(height: 40),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle previous action
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F51B5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AnganWadiScreeningFormSeven(previousData: {},),
                            ),
                          );  
                        // Handle next action
                        if (hasYesDiseases) {
                          
                          // Print selected diseases and their treatment details
                          diseases.entries
                              .where((e) => e.value)
                              .forEach((disease) {
                            print('Disease: ${disease.key}');
                            print(
                                '  - Treatment: ${treatmentOptions[disease.key]! ? "Treated" : "Refer"}');
                            if (!treatmentOptions[disease.key]!) {
                              print(
                                  '  - Referred to: ${referralOptions[disease.key]}');
                            }
                            print(
                                '  - Note: ${treatmentNoteControllers[disease.key]?.text}');
                          });
                        } else {
                          print('No diseases selected');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3F51B5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Next',
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    treatmentNoteControllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
