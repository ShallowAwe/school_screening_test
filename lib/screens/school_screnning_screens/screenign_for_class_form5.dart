import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form6.dart';

class ScreenignForClassFormFive extends StatefulWidget {
  final Map<String, dynamic> previousData;
  
  const ScreenignForClassFormFive({
    super.key,
    required this.previousData,
  });

  @override
  State<ScreenignForClassFormFive> createState() => _ScreenignForClassFormFiveState();
}

class _ScreenignForClassFormFiveState extends State<ScreenignForClassFormFive> {
  // Disease configuration with API field names and prefixes
  final List<Map<String, String>> diseaseConfig = [
    {
      'display': 'Vision Impairment',
      'field': 'visionImpairment',
      'prefix': 'vision',
      'treatedField': 'visionTreated',
      'referField': 'visionRefer',
    },
    {
      'display': 'Hearing Impairment',
      'field': 'hearingImpairment',
      'prefix': 'hearing',
      'treatedField': 'hearingTreated',
      'referField': 'hearingRefer',
    },
    {
      'display': 'Neuro-motor Impairment',
      'field': 'neuromotorImpairment',
      'prefix': 'neuro',
      'treatedField': 'neuromotorTreated',
      'referField': 'neuromotorRefer',
    },
    {
      'display': 'Motor delay',
      'field': 'motorDelay',
      'prefix': 'motor',
      'treatedField': 'motorDealyTrated',
      'referField': 'motorDelayRefer',
    },
    {
      'display': 'Cognitive Delay',
      'field': 'cognitiveDelay',
      'prefix': 'cognitive',
      'treatedField': 'cognitiveTrated',
      'referField': 'cognitiveRefer',
    },
    {
      'display': 'Speech and Language Delay',
      'field': 'speechAndLanguageDelay',
      'prefix': 'speech',
      'treatedField': 'speechTreated',
      'referField': 'speechRefer',
    },
    {
      'display': 'Behavioural Disorder (Autism)',
      'field': 'behaviouralDisorder',
      'prefix': 'behavoiural',
      'treatedField': 'behaviouralTreated',
      'referField': 'behavoiuralRefer',
    },
    {
      'display': 'Learning Disorder',
      'field': 'learningDisorder',
      'prefix': 'learning',
      'treatedField': 'learningTreated',
      'referField': 'learningRefer',
    },
    {
      'display': 'Attention Deficit Hyperactivity Disorder',
      'field': 'attentionDeficitHyperactivityDisorder',
      'prefix': 'attention',
      'treatedField': 'attentionTreated',
      'referField': 'attentionRefer',
    },
    {
      'display': 'Others',
      'field': 'other_ddid',
      'prefix': 'other_ddid',
      'treatedField': 'other_ddidTreated',
      'referField': 'other_ddidRefer',
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
  Map<String, bool> diseases = {};
  Map<String, bool> treatmentOptions = {}; // true = treated, false = refer
  Map<String, String> referralOptions = {};
  Map<String, TextEditingController> noteControllers = {};

  bool hasNoDiseases = true;
  bool hasYesDiseases = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize state for each disease
    for (var disease in diseaseConfig) {
      String key = disease['field']!;
      diseases[key] = false;
      treatmentOptions[key] = true; // Default to treated
      referralOptions[key] = '';
      noteControllers[key] = TextEditingController();
    }
  }

  void _showReferralPopup(String diseaseKey, String prefix) {
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
                            referralOptions[diseaseKey] = referral['display']!;
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
  
  // Add developmental delay flag (PascalCase)
  outputData['DevelopmentalDelayIncludingDisability'] = hasYesDiseases;
  
  // Add disease-specific data
  for (var diseaseConf in diseaseConfig) {
    String field = diseaseConf['field']!;
    String prefix = diseaseConf['prefix']!;
    String treatedField = diseaseConf['treatedField']!;
    String referField = diseaseConf['referField']!;
    
    if (diseases[field] == true) {
      // Disease is selected
      outputData[_toPascalCase(field)] = true;
      
      // Add treatment/refer flags
      outputData[_toPascalCase(treatedField)] = treatmentOptions[field] == true;
      outputData[_toPascalCase(referField)] = treatmentOptions[field] == false;
      
      // Add referral options
      String selectedReferral = referralOptions[field] ?? '';
      
      for (var referral in referralList) {
        String referralField = referral['field']!;
        String fullReferralField = _getReferralFieldName(prefix, referralField, field);
        outputData[fullReferralField] = selectedReferral == referral['display'];
      }
      
      // Add note
      outputData['${_toPascalCase(field)}_Note'] = noteControllers[field]?.text ?? '';
    } else {
      // Disease not selected - set all to false
      outputData[_toPascalCase(field)] = false;
      outputData[_toPascalCase(treatedField)] = false;
      outputData[_toPascalCase(referField)] = false;
      
      for (var referral in referralList) {
        String referralField = referral['field']!;
        String fullReferralField = _getReferralFieldName(prefix, referralField, field);
        outputData[fullReferralField] = false;
      }
      
      outputData['${_toPascalCase(field)}_Note'] = '';
    }
  }
  
  return outputData;
}

String _toPascalCase(String input) {
  // Handle main disease fields
  if (input == 'visionImpairment') return 'VisionImpairment';
  if (input == 'hearingImpairment') return 'HearingImpairment';
  if (input == 'neuromotorImpairment') return 'NeuromotorImpairment';
  if (input == 'motorDelay') return 'MotorDelay';
  if (input == 'cognitiveDelay') return 'CognitiveDelay';
  if (input == 'speechAndLanguageDelay') return 'SpeechAndLanguageDelay';
  if (input == 'behaviouralDisorder') return 'BehaviouralDisorder';
  if (input == 'learningDisorder') return 'LearningDisorder';
  if (input == 'attentionDeficitHyperactivityDisorder') return 'AttentionDeficitHyperactivityDisorder';
  if (input == 'other_ddid') return 'other_ddid';
  
  // Handle treated fields
  if (input == 'visionTreated') return 'VisionTreated';
  if (input == 'hearingTreated') return 'HearingTreated';
  if (input == 'neuromotorTreated') return 'NeuromotorTreated';
  if (input == 'motorDealyTrated') return 'MotorDealyTrated'; // Note: typo in C# model
  if (input == 'cognitiveTrated') return 'CognitiveTrated';
  if (input == 'speechTreated') return 'SpeechTreated';
  if (input == 'behaviouralTreated') return 'BehaviouralTreated';
  if (input == 'learningTreated') return 'LearningTreated';
  if (input == 'attentionTreated') return 'AttentionTreated';
  if (input == 'other_ddidTreated') return 'other_ddidTreated';
  
  // Handle refer fields
  if (input == 'visionRefer') return 'VisionRefer';
  if (input == 'hearingRefer') return 'HearingRefer';
  if (input == 'neuromotorRefer') return 'NeuromotorRefer';
  if (input == 'motorDelayRefer') return 'MotorDelayRefer';
  if (input == 'cognitiveRefer') return 'CognitiveRefer';
  if (input == 'speechRefer') return 'SpeechRefer';
  if (input == 'behavoiuralRefer') return 'BehavoiuralRefer'; // Note: typo in C# model
  if (input == 'learningRefer') return 'LearningRefer';
  if (input == 'attentionRefer') return 'AttentionRefer';
  if (input == 'other_ddidRefer') return 'other_ddidRefer';
  
  return input;
}

String _getReferralFieldName(String prefix, String referralField, String diseaseField) {
  // Based on C# model patterns:
  // Vision: Vision_Refer_RH, VisionRefer_SKNagpur
  // Hearing: Hearing_Refer_RH, HearingRefer_SKNagpur
  // Neuro: Neuro_Refer_RH, NeuromotorRefer_SKNagpur
  // Motor: Motor_Refer_RH, MotorDelayRefer_SKNagpur
  // Cognitive: Cognitive_Refer_RH, CognitiveRefer_SKNagpur
  // Speech: Speech_Refer_RH, SpeechRefer_SKNagpur
  // Behavoiural: Behavoiural_Refer_RH, BehavoiuralRefer_SKNagpur (note typo in C#)
  // Learning: Learning_Refer_RH, LearningRefer_SKNagpur
  // Attention: Attention_Refer_RH, AttentionRefer_SKNagpur
  // other_ddid: other_ddidRefer_RH, other_ddidRefer_SKNagpur, other_ddidMJMJYAndMOUY
  
  if (referralField == 'SKNagpur') {
    // SKNagpur has different pattern
    if (prefix == 'other_ddid') {
      return 'other_ddidRefer_SKNagpur';
    }
    return '${_toPascalCase(diseaseField)}Refer_SKNagpur';
  } else if (referralField == 'MJMJYAndMOUY') {
    // Special case for MJMJYAndMOUY
    if (prefix == 'other_ddid') {
      return 'other_ddidMJMJYAndMOUY';
    }
    return '${_getPrefixForRefer(prefix)}_Refer_MJMJYAndMOUY';
  } else {
    // Regular pattern: prefix_Refer_RH
    if (prefix == 'other_ddid') {
      return 'other_ddidRefer_$referralField';
    }
    return '${_getPrefixForRefer(prefix)}_Refer_$referralField';
  }
}

String _getPrefixForRefer(String prefix) {
  // Convert prefix to match C# model
  if (prefix == 'vision') return 'Vision';
  if (prefix == 'hearing') return 'Hearing';
  if (prefix == 'neuro') return 'Neuro';
  if (prefix == 'motor') return 'Motor';
  if (prefix == 'cognitive') return 'Cognitive';
  if (prefix == 'speech') return 'Speech';
  if (prefix == 'behavoiural') return 'Behavoiural'; // Note: matches C# typo
  if (prefix == 'learning') return 'Learning';
  if (prefix == 'attention') return 'Attention';
  return prefix;
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
          "Screening For ${widget.previousData['className']}",
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
                '5/8',
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
                  'D. Developmental Delay\nIncluding Disability',
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
                          diseases.updateAll((key, value) => false);
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

            // Show disease list only if "Yes" is selected
            if (hasYesDiseases) ...[
              ...diseaseConfig.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> diseaseConf = entry.value;
                String diseaseKey = diseaseConf['field']!;
                String displayName = diseaseConf['display']!;
                String prefix = diseaseConf['prefix']!;

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
                              diseases[diseaseKey] = !diseases[diseaseKey]!;
                              if (!diseases[diseaseKey]!) {
                                treatmentOptions[diseaseKey] = true;
                                referralOptions[diseaseKey] = '';
                                noteControllers[diseaseKey]?.clear();
                              }
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: diseases[diseaseKey]!
                                  ? Color(0xFF2196F3)
                                  : Colors.transparent,
                              border: Border.all(
                                color: diseases[diseaseKey]!
                                    ? Color(0xFF2196F3)
                                    : Colors.grey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: diseases[diseaseKey]!
                                ? Icon(Icons.check, color: Colors.white, size: 18)
                                : null,
                          ),
                        ),
                      ],
                    ),

                    if (diseases[diseaseKey]!) ...[
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
                                      treatmentOptions[diseaseKey] = false;
                                    });
                                    _showReferralPopup(diseaseKey, prefix);
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
                                        ? Icon(Icons.check, color: Colors.white, size: 14)
                                        : null,
                                  ),
                                ),
                                if (!treatmentOptions[diseaseKey]! &&
                                    referralOptions[diseaseKey]!.isNotEmpty) ...[
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
                              treatmentOptions[diseaseKey]!
                                  ? 'Enter Treated Note'
                                  : 'Enter Refer Note',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                            SizedBox(height: 8),
                            Container(
                              child: TextField(
                                controller: noteControllers[diseaseKey],
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
                        backgroundColor: const Color(0xFF4A5568),
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
                        print('Combined Data: $combinedData');
                        
                        // Navigate to next page with combined data
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreeningForClassFormSix(
                              previousData: combinedData,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A5568),
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