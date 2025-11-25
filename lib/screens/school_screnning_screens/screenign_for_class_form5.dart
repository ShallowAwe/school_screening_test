import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form6.dart';

class ScreenignForClassFormFive extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const ScreenignForClassFormFive({super.key, required this.previousData});

  @override
  State<ScreenignForClassFormFive> createState() =>
      _ScreenignForClassFormFiveState();
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
      'display': 'Motor Delay',
      'field': 'motorDelay',
      'prefix': 'motor',
      'treatedField': 'motorDelayTreated',
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
    {'display': 'SKNagpur', 'field': 'SKNagpur'},
    {'display': 'RH', 'field': 'RH'},
    {'display': 'SDH', 'field': 'SDH'},
    {'display': 'DH', 'field': 'DH'},
    // {'display': 'GMC', 'field': 'GMC'},
    // {'display': 'IGMC', 'field': 'IGMC'},
    // {'display': 'MJMJY & MOUY', 'field': 'MJMJYAndMOUY'},
    // {'display': 'DEIC', 'field': 'DEIC'},
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _buildOutputData() {
    Map<String, dynamic> outputData = Map<String, dynamic>.from(
      widget.previousData,
    );

    outputData['developmentalDelayIncludingDisability'] = hasYesDiseases;

    for (var diseaseConf in diseaseConfig) {
      String field = diseaseConf['field']!;
      String prefix = diseaseConf['prefix']!;
      String treatedField = diseaseConf['treatedField']!;
      String referField = diseaseConf['referField']!;

      if (diseases[field] == true) {
        outputData[field] = true;
        outputData[treatedField] = treatmentOptions[field] == true;
        outputData[referField] = treatmentOptions[field] == false;

        String selectedReferral = referralOptions[field] ?? '';

        for (var referral in referralList) {
          String referralFieldName = referral['field']!;
          String fullReferralField = _getReferralFieldName(
            prefix,
            referralFieldName,
            field,
          );
          outputData[fullReferralField] =
              selectedReferral == referral['display'];
        }

        outputData['${field}_Note'] = noteControllers[field]?.text ?? '';
      } else {
        outputData[field] = false;
        outputData[treatedField] = false;
        outputData[referField] = false;

        for (var referral in referralList) {
          String referralFieldName = referral['field']!;
          String fullReferralField = _getReferralFieldName(
            prefix,
            referralFieldName,
            field,
          );
          outputData[fullReferralField] = false;
        }

        outputData['${field}_Note'] = '';
      }
    }

    return outputData;
  }

  String _getReferralFieldName(
    String prefix,
    String referralField,
    String diseaseField,
  ) {
    if (referralField == 'SKNagpur') {
      if (prefix == 'other_ddid') {
        return 'other_ddidRefer_SKNagpur';
      }
      return '${diseaseField}Refer_SKNagpur';
    } else if (referralField == 'MJMJYAndMOUY') {
      if (prefix == 'other_ddid') {
        return 'other_ddidMJMJYAndMOUY';
      }
      return '${prefix}_Refer_MJMJYAndMOUY';
    } else {
      if (prefix == 'other_ddid') {
        return 'other_ddidRefer_$referralField';
      }
      return '${prefix}_Refer_$referralField';
    }
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
          "Screening Form",
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
                          color: hasNoDiseases
                              ? Color(0xFF2196F3)
                              : Colors.transparent,
                          border: Border.all(
                            color: hasNoDiseases
                                ? Color(0xFF2196F3)
                                : Colors.grey,
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
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  )
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
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          )
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
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          )
                                        : null,
                                  ),
                                ),
                                if (!treatmentOptions[diseaseKey]! &&
                                    referralOptions[diseaseKey]!
                                        .isNotEmpty) ...[
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      referralOptions[diseaseKey]!,
                                      style: TextStyle(
                                        fontSize: 14,

                                        fontWeight: FontWeight.w500,
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
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              child: TextField(
                                controller: noteControllers[diseaseKey],
                                maxLines: 1,
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
                                    borderSide: BorderSide(
                                      color: Color(0xFF2196F3),
                                      width: 2,
                                    ),
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
              }),
            ],

            SizedBox(height: 40),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 25),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
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
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> combinedData =
                              _buildOutputData();

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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in noteControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
