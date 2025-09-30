import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form8.dart';

class ScreeningForClassFormSeven extends StatefulWidget {
  final Map<String, dynamic> previousData;
  
  const ScreeningForClassFormSeven({
    super.key,
    required this.previousData,
  });

  @override
  State<ScreeningForClassFormSeven> createState() => _ScreeningForClassFormSevenState();
}

class _ScreeningForClassFormSevenState extends State<ScreeningForClassFormSeven> {
  // Disability configuration with API field names
  final Map<String, String> disabilityConfig = {
  'display': 'Disability',
  'field': 'Disibility',           // Capital D
  'treatedField': 'DisibilityTreated',  // Capital D
  'referField': 'DisibilityRefer',      // Capital D
};

  // Referral dropdown options with API field names
  final List<Map<String, String>> referralList = [
    {'display': 'Samaj Kalyan Nagpur', 'field': 'SKNagpur'},
    {'display': 'RH', 'field': 'RH'},
    {'display': 'SDH', 'field': 'SDH'},
    {'display': 'DH', 'field': 'DH'},
    {'display': 'GMC', 'field': 'GMC'},
    {'display': 'IGMC', 'field': 'IGMC'},
    {'display': 'MJMJY & MOUY', 'field': 'MJMJYAndMOUY'},
    {'display': 'DEIC', 'field': 'DEIC'},
  ];

  // State management
  bool hasDisability = false;
  bool treatmentOption = true; // true = treated, false = refer
  String selectedReferral = '';
  TextEditingController noteController = TextEditingController();

  // No/Yes selection state
  bool hasNoDiseases = true;
  bool hasYesDiseases = false;

  @override
  void initState() {
    super.initState();
    // Initialize with "No" selected
    hasNoDiseases = true;
    hasYesDiseases = false;
    hasDisability = false;
    treatmentOption = true; // Default to "Treated"
    selectedReferral = '';
  }

  void _showReferralPopup() {
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
                  Map<String, String> referral = entry.value;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedReferral = referral['display']!;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Text(
                            '${index + 1}. ${referral['display']}',
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

  Map<String, dynamic> _buildOutputData() {
    Map<String, dynamic> outputData = Map<String, dynamic>.from(widget.previousData);
    
    if (hasYesDiseases && hasDisability) {
      // Disability is selected
      outputData[disabilityConfig['field']!] = true;
      outputData[disabilityConfig['treatedField']!] = treatmentOption;
      outputData[disabilityConfig['referField']!] = !treatmentOption;
      
      // Add referral options
      if (!treatmentOption) {
        // Set referral flags based on selection
        for (var referral in referralList) {
          String referralField = referral['field']!;
          String fullReferralField;
          
          if (referralField == 'SKNagpur') {
            fullReferralField = '${disabilityConfig['referField']}_$referralField';
          } else {
            fullReferralField = '${disabilityConfig['field']}_$referralField';
          }
          
          outputData[fullReferralField] = selectedReferral == referral['display'];
        }
      } else {
        // Set all referral options to false if treated
        for (var referral in referralList) {
          String referralField = referral['field']!;
          String fullReferralField;
          
          if (referralField == 'SKNagpur') {
            fullReferralField = '${disabilityConfig['referField']}_$referralField';
          } else {
            fullReferralField = '${disabilityConfig['field']}_$referralField';
          }
          
          outputData[fullReferralField] = false;
        }
      }
      
      // Add note
      outputData['${disabilityConfig['field']}_Note'] = noteController.text;
    } else {
      // No disability selected - set all to false
      outputData[disabilityConfig['field']!] = false;
      outputData[disabilityConfig['treatedField']!] = false;
      outputData[disabilityConfig['referField']!] = false;
      
      for (var referral in referralList) {
        String referralField = referral['field']!;
        String fullReferralField;
        
        if (referralField == 'SKNagpur') {
          fullReferralField = '${disabilityConfig['referField']}_$referralField';
        } else {
          fullReferralField = '${disabilityConfig['field']}_$referralField';
        }
        
        outputData[fullReferralField] = false;
      }
      
      outputData['${disabilityConfig['field']}_Note'] = '';
    }
    
    return outputData;
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
          'Screening For 1st Class',
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
                '7/8',
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
                          hasDisability = false;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: hasNoDiseases ? Color(0xFF2196F3) : Colors.transparent,
                          border: Border.all(
                            color: hasNoDiseases ? Color(0xFF2196F3) : Colors.grey,
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
                          color: hasYesDiseases ? Color(0xFF2196F3) : Colors.transparent,
                          border: Border.all(
                            color: hasYesDiseases ? Color(0xFF2196F3) : Colors.grey,
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

            // Show disability option only if "Yes" is selected
            if (hasYesDiseases) ...[
              // Disability Option
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '1. ${disabilityConfig['display']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            hasDisability = !hasDisability;
                            if (!hasDisability) {
                              treatmentOption = true;
                              selectedReferral = '';
                              noteController.clear();
                            }
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: hasDisability
                                ? Color(0xFF2196F3)
                                : Colors.transparent,
                            border: Border.all(
                              color: hasDisability
                                  ? Color(0xFF2196F3)
                                  : Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: hasDisability
                              ? Icon(Icons.check, color: Colors.white, size: 18)
                              : null,
                        ),
                      ),
                    ],
                  ),

                  // Treatment options when disability is selected
                  if (hasDisability) ...[
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
                                    treatmentOption = true;
                                    selectedReferral = '';
                                  });
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: treatmentOption
                                        ? Color(0xFF2196F3)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: treatmentOption
                                          ? Color(0xFF2196F3)
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: treatmentOption
                                      ? Icon(Icons.check, color: Colors.white, size: 14)
                                      : null,
                                ),
                              ),
                              SizedBox(width: 24),
                              Text('Refer', style: TextStyle(fontSize: 16)),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    treatmentOption = false;
                                  });
                                  _showReferralPopup();
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: !treatmentOption
                                        ? Color(0xFF2196F3)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: !treatmentOption
                                          ? Color(0xFF2196F3)
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: !treatmentOption
                                      ? Icon(Icons.check, color: Colors.white, size: 14)
                                      : null,
                                ),
                              ),
                              if (!treatmentOption && selectedReferral.isNotEmpty) ...[
                                SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2196F3).withOpacity(0.1),
                                      border: Border.all(
                                        color: Color(0xFF2196F3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      selectedReferral,
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
                            treatmentOption
                                ? 'Enter Treated Note'
                                : 'Enter Refer Note',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: TextField(
                              controller: noteController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF2196F3), width: 2),
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
              ),
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
                        Map<String, dynamic> combinedData = _buildOutputData();
                        
                        // Debug print
                        print('Combined Data from Form 7: $combinedData');
                        
                        // Navigate to next page with combined data
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreeningForClassFormEight(
                              combinedData: combinedData,
                            ),
                          ),
                        );
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
    noteController.dispose();
    super.dispose();
  }
}