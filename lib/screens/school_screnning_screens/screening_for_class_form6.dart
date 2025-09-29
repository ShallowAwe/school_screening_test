import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form7.dart';
// Import your next screen here
// import 'package:school_test/screens/school_screnning_screens/screening_for_class_form7.dart';

class ScreeningForClassFormSix extends StatefulWidget {
  final Map<String, dynamic> previousData;
  
  const ScreeningForClassFormSix({
    super.key,
    required this.previousData,
  });

  @override
  State<ScreeningForClassFormSix> createState() => _ScreeningForClassFormSixState();
}

class _ScreeningForClassFormSixState extends State<ScreeningForClassFormSix> {
  // Adolescent specific questions configuration with API field names and prefixes
  final List<Map<String, String>> adolescentConfig = [
    {
      'display': 'Growing Up Concerns',
      'field': 'growingUpConcerns',
      'prefix': 'growing',
      'treatedField': 'growingTreated',
      'referField': 'growingRefer',
    },
    {
      'display': 'Substance Abuse',
      'field': 'substanceAbuse',
      'prefix': 'substance',
      'treatedField': 'substanceTreated',
      'referField': 'substanceRefer',
    },
    {
      'display': 'Feel Depressed',
      'field': 'feelDepressed',
      'prefix': 'feel',
      'treatedField': 'feelTreated',
      'referField': 'feelRefer',
    },
    {
      'display': 'Delay in Menstrual Cycles',
      'field': 'delayInMenstrualCycles',
      'prefix': 'delay',
      'treatedField': 'delayTreated',
      'referField': 'delayRefer',
    },
    {
      'display': 'Irregular Periods',
      'field': 'irregularPeriods',
      'prefix': 'irregular',
      'treatedField': 'irregularTreated',
      'referField': 'irregularRefer',
    },
    {
      'display': 'Pain or Burning Sensation While Urinating',
      'field': 'painOrBurningSensationWhileUrinating',
      'prefix': 'painOrBurning',
      'treatedField': 'painOrBurningTreated',
      'referField': 'painOrBurningRefer',
    },
    {
      'display': 'Discharge',
      'field': 'discharge',
      'prefix': 'discharge',
      'treatedField': 'dischargeTreated',
      'referField': 'dischargeRefer',
    },
    {
      'display': 'Pain During Menstruation',
      'field': 'painDuringMenstruation',
      'prefix': 'painDuring',
      'treatedField': 'painDuringTreated',
      'referField': 'painDuringRefer',
    },
    {
      'display': 'Others',
      'field': 'other_asq',
      'prefix': 'other_asq',
      'treatedField': 'other_asqTreated',
      'referField': 'other_asqRefer',
    },
  ];

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
  Map<String, bool> adolescentIssues = {};
  Map<String, bool> treatmentOptions = {}; // true = treated, false = refer
  Map<String, String> referralOptions = {};
  Map<String, TextEditingController> noteControllers = {};

  bool hasNoIssues = true;
  bool hasYesIssues = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize state for each adolescent issue
    for (var issue in adolescentConfig) {
      String key = issue['field']!;
      adolescentIssues[key] = false;
      treatmentOptions[key] = true; // Default to treated
      referralOptions[key] = '';
      noteControllers[key] = TextEditingController();
    }
  }

  void _showReferralPopup(String issueKey, String prefix) {
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
                ...referralList.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, String> referral = entry.value;

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            referralOptions[issueKey] = referral['display']!;
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
    
    // Add adolescent specific questionnaire flag
    outputData['adolescentSpecificQuestionnare'] = hasYesIssues;
    
    // Add issue-specific data
    for (var issueConf in adolescentConfig) {
      String field = issueConf['field']!;
      String prefix = issueConf['prefix']!;
      String treatedField = issueConf['treatedField']!;
      String referField = issueConf['referField']!;
      
      if (adolescentIssues[field] == true) {
        // Issue is selected
        outputData[field] = true;
        
        // Add treatment/refer flags
        outputData[treatedField] = treatmentOptions[field] == true;
        outputData[referField] = treatmentOptions[field] == false;
        
        // Add referral options if refer is selected
        if (treatmentOptions[field] == false) {
          for (var referral in referralList) {
            String referralField = referral['field']!;
            String selectedReferral = referralOptions[field] ?? '';
            
            // Special handling for different prefix patterns
            String fullReferralField;
            if (prefix == 'other_asq') {
              if (referralField == 'MJMJYAndMOUY') {
                fullReferralField = '${prefix}MJMJYAndMOUY';
              } else if (referralField == 'SKNagpur') {
                fullReferralField = '${prefix}Refer_SKNagpur';
              } else {
                fullReferralField = '${prefix}Refer_$referralField';
              }
            } else if (referralField == 'SKNagpur') {
              fullReferralField = '${referField}_SKNagpur';
            } else {
              fullReferralField = '${prefix}_Refer_$referralField';
            }
            
            outputData[fullReferralField] = selectedReferral == referral['display'];
          }
        } else {
          // Set all referral options to false if treated
          for (var referral in referralList) {
            String referralField = referral['field']!;
            String fullReferralField;
            if (prefix == 'other_asq') {
              if (referralField == 'MJMJYAndMOUY') {
                fullReferralField = '${prefix}MJMJYAndMOUY';
              } else if (referralField == 'SKNagpur') {
                fullReferralField = '${prefix}Refer_SKNagpur';
              } else {
                fullReferralField = '${prefix}Refer_$referralField';
              }
            } else if (referralField == 'SKNagpur') {
              fullReferralField = '${referField}_SKNagpur';
            } else {
              fullReferralField = '${prefix}_Refer_$referralField';
            }
            outputData[fullReferralField] = false;
          }
        }
        
        // Add note
        outputData['${field}_Note'] = noteControllers[field]?.text ?? '';
      } else {
        // Issue not selected - set all to false
        outputData[field] = false;
        outputData[treatedField] = false;
        outputData[referField] = false;
        
        for (var referral in referralList) {
          String referralField = referral['field']!;
          String fullReferralField;
          if (prefix == 'other_asq') {
            if (referralField == 'MJMJYAndMOUY') {
              fullReferralField = '${prefix}MJMJYAndMOUY';
            } else if (referralField == 'SKNagpur') {
              fullReferralField = '${prefix}Refer_SKNagpur';
            } else {
              fullReferralField = '${prefix}Refer_$referralField';
            }
          } else if (referralField == 'SKNagpur') {
            fullReferralField = '${referField}_SKNagpur';
          } else {
            fullReferralField = '${prefix}_Refer_$referralField';
          }
          outputData[fullReferralField] = false;
        }
        
        outputData['${field}_Note'] = '';
      }
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
                '6/8',
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
                  'E. Adolescent Specific\nQuestionnaire',
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
                          hasNoIssues = true;
                          hasYesIssues = false;
                          adolescentIssues.updateAll((key, value) => false);
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: hasNoIssues ? Color(0xFF2196F3) : Colors.transparent,
                          border: Border.all(
                            color: hasNoIssues ? Color(0xFF2196F3) : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: hasNoIssues
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
                          hasNoIssues = false;
                          hasYesIssues = true;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: hasYesIssues ? Color(0xFF2196F3) : Colors.transparent,
                          border: Border.all(
                            color: hasYesIssues ? Color(0xFF2196F3) : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: hasYesIssues
                            ? Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 24),

            // Show adolescent issues list only if "Yes" is selected
            if (hasYesIssues) ...[
              ...adolescentConfig.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> issueConf = entry.value;
                String issueKey = issueConf['field']!;
                String displayName = issueConf['display']!;
                String prefix = issueConf['prefix']!;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}. $displayName',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              adolescentIssues[issueKey] = !adolescentIssues[issueKey]!;
                              if (!adolescentIssues[issueKey]!) {
                                treatmentOptions[issueKey] = true;
                                referralOptions[issueKey] = '';
                                noteControllers[issueKey]?.clear();
                              }
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: adolescentIssues[issueKey]!
                                  ? Color(0xFF2196F3)
                                  : Colors.transparent,
                              border: Border.all(
                                color: adolescentIssues[issueKey]!
                                    ? Color(0xFF2196F3)
                                    : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: adolescentIssues[issueKey]!
                                ? Icon(Icons.check, color: Colors.white, size: 18)
                                : null,
                          ),
                        ),
                      ],
                    ),

                    if (adolescentIssues[issueKey]!) ...[
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
                                      treatmentOptions[issueKey] = true;
                                      referralOptions[issueKey] = '';
                                    });
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: treatmentOptions[issueKey]!
                                          ? Color(0xFF2196F3)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: treatmentOptions[issueKey]!
                                            ? Color(0xFF2196F3)
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: treatmentOptions[issueKey]!
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
                                      treatmentOptions[issueKey] = false;
                                    });
                                    _showReferralPopup(issueKey, prefix);
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: !treatmentOptions[issueKey]!
                                          ? Color(0xFF2196F3)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: !treatmentOptions[issueKey]!
                                            ? Color(0xFF2196F3)
                                            : Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: !treatmentOptions[issueKey]!
                                        ? Icon(Icons.check, color: Colors.white, size: 14)
                                        : null,
                                  ),
                                ),
                                if (!treatmentOptions[issueKey]! &&
                                    referralOptions[issueKey]!.isNotEmpty) ...[
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
                                        referralOptions[issueKey]!,
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
                              treatmentOptions[issueKey]!
                                  ? 'Enter Treated Note'
                                  : 'Enter Refer Note',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            SizedBox(height: 8),
                            Container(
                              child: TextField(
                                controller: noteControllers[issueKey],
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
                        print('Combined Data from Form 6: $combinedData');
                        
                        // Navigate to next page with combined data
                        // Uncomment when you create the next screen
                        
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreeningForClassFormSeven(
                              previousData: combinedData,
                            ),
                          ),
                        );
                        
                        
                        // // Temporary: Show success message
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Form completed successfully! Check console for data.'),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );
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
    noteControllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }
}