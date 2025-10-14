import 'package:flutter/material.dart';
import 'package:school_test/screens/anganWadi_screening-forms/screening_for_anganwadi_form6.dart';


class ScreenignForAngnwadiFormFive extends StatefulWidget {
    final Map<String, dynamic> previousData;
  const ScreenignForAngnwadiFormFive({super.key, required this.previousData});

  @override
  State<ScreenignForAngnwadiFormFive> createState() => _ScreenignForAngnwadiFormFiveState();
}

class _ScreenignForAngnwadiFormFiveState extends State<ScreenignForAngnwadiFormFive> {
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
        String fullReferralField = _getReferralFieldName(prefix, referralFieldName, field);
        outputData[fullReferralField] = selectedReferral == referral['display'];
      }
      
      outputData['${field}_Note'] = noteControllers[field]?.text ?? '';
    } else {
      outputData[field] = false;
      outputData[treatedField] = false;
      outputData[referField] = false;
      
      for (var referral in referralList) {
        String referralFieldName = referral['field']!;
        String fullReferralField = _getReferralFieldName(prefix, referralFieldName, field);
        outputData[fullReferralField] = false;
      }
      
      outputData['${field}_Note'] = '';
    }
  }
  
  return outputData;
}


 String _getReferralFieldName(String prefix, String referralField, String diseaseField) {
  // Handle SKNagpur referrals
  if (referralField == 'SKNagpur') {
    if (diseaseField == 'visionImpairment') return 'visionRefer_SKNagpur';
    if (diseaseField == 'hearingImpairment') return 'hearingRefer_SKNagpur';
    if (diseaseField == 'neuromotorImpairment') return 'neuromotorRefer_SKNagpur';
    if (diseaseField == 'motorDelay') return 'motorDelayRefer_SKNagpur';
    if (diseaseField == 'cognitiveDelay') return 'cognitiveRefer_SKNagpur';
    if (diseaseField == 'speechAndLanguageDelay') return 'speechRefer_SKNagpur';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiuralRefer_SKNagpur';
    if (diseaseField == 'learningDisorder') return 'learningRefer_SKNagpur';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attentionRefer_SKNagpur';
    if (diseaseField == 'other_ddid') return 'other_ddidRefer_SKNagpur';
  }
  
  // Handle RH referrals
  if (referralField == 'RH') {
    if (diseaseField == 'visionImpairment') return 'vision_Refer_RH';
    if (diseaseField == 'hearingImpairment') return 'hearing_Refer_RH';
    if (diseaseField == 'neuromotorImpairment') return 'neuro_Refer_RH';
    if (diseaseField == 'motorDelay') return 'motor_Refer_RH';
    if (diseaseField == 'cognitiveDelay') return 'cognitive_Refer_RH';
    if (diseaseField == 'speechAndLanguageDelay') return 'speech_Refer_RH';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiural_Refer_RH';
    if (diseaseField == 'learningDisorder') return 'learning_Refer_RH';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attention_Refer_RH';
    if (diseaseField == 'other_ddid') return 'other_ddidRefer_RH';
  }
  
  // Handle SDH referrals
  if (referralField == 'SDH') {
    if (diseaseField == 'visionImpairment') return 'vision_Refer_SDH';
    if (diseaseField == 'hearingImpairment') return 'hearing_Refer_SDH';
    if (diseaseField == 'neuromotorImpairment') return 'neuro_Refer_SDH';
    if (diseaseField == 'motorDelay') return 'motor_Refer_SDH';
    if (diseaseField == 'cognitiveDelay') return 'cognitive_Refer_SDH';
    if (diseaseField == 'speechAndLanguageDelay') return 'speech_Refer_SDH';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiural_Refer_SDH';
    if (diseaseField == 'learningDisorder') return 'learning_Refer_SDH';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attention_Refer_SDH';
    if (diseaseField == 'other_ddid') return 'other_ddidRefer_SDH';
  }
  
  // Handle DH referrals
  if (referralField == 'DH') {
    if (diseaseField == 'visionImpairment') return 'vision_Refer_DH';
    if (diseaseField == 'hearingImpairment') return 'hearing_Refer_DH';
    if (diseaseField == 'neuromotorImpairment') return 'neuro_Refer_DH';
    if (diseaseField == 'motorDelay') return 'motor_Refer_DH';
    if (diseaseField == 'cognitiveDelay') return 'cognitive_Refer_DH';
    if (diseaseField == 'speechAndLanguageDelay') return 'speech_Refer_DH';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiural_Refer_DH';
    if (diseaseField == 'learningDisorder') return 'learning_Refer_DH';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attention_Refer_DH';
    if (diseaseField == 'other_ddid') return 'other_ddidRefer_DH';
  }
  
  // Handle GMC referrals
  if (referralField == 'GMC') {
    if (diseaseField == 'visionImpairment') return 'vision_Refer_GMC';
    if (diseaseField == 'hearingImpairment') return 'hearing_Refer_GMC';
    if (diseaseField == 'neuromotorImpairment') return 'neuro_Refer_GMC';
    if (diseaseField == 'motorDelay') return 'motor_Refer_GMC';
    if (diseaseField == 'cognitiveDelay') return 'cognitive_Refer_GMC';
    if (diseaseField == 'speechAndLanguageDelay') return 'speech_Refer_GMC';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiural_Refer_GMC';
    if (diseaseField == 'learningDisorder') return 'learning_Refer_GMC';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attention_Refer_GMC';
    if (diseaseField == 'other_ddid') return 'other_ddidRefer_GMC';
  }
  
  // Handle IGMC referrals
  if (referralField == 'IGMC') {
    if (diseaseField == 'visionImpairment') return 'vision_Refer_IGMC';
    if (diseaseField == 'hearingImpairment') return 'hearing_Refer_IGMC';
    if (diseaseField == 'neuromotorImpairment') return 'neuro_Refer_IGMC';
    if (diseaseField == 'motorDelay') return 'motor_Refer_IGMC';
    if (diseaseField == 'cognitiveDelay') return 'cognitive_Refer_IGMC';
    if (diseaseField == 'speechAndLanguageDelay') return 'speech_Refer_IGMC';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiural_Refer_IGMC';
    if (diseaseField == 'learningDisorder') return 'learning_Refer_IGMC';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attention_Refer_IGMC';
    if (diseaseField == 'other_ddid') return 'other_ddidRefer_IGMC';
  }
  
  // Handle MJMJYAndMOUY referrals
  if (referralField == 'MJMJYAndMOUY') {
    if (diseaseField == 'visionImpairment') return 'vision_Refer_MJMJYAndMOUY';
    if (diseaseField == 'hearingImpairment') return 'hearing_Refer_MJMJYAndMOUY';
    if (diseaseField == 'neuromotorImpairment') return 'neuro_Refer_MJMJYAndMOUY';
    if (diseaseField == 'motorDelay') return 'motor_Refer_MJMJYAndMOUY';
    if (diseaseField == 'cognitiveDelay') return 'cognitive_Refer_MJMJYAndMOUY';
    if (diseaseField == 'speechAndLanguageDelay') return 'speech_Refer_MJMJYAndMOUY';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiural_Refer_MJMJYAndMOUY';
    if (diseaseField == 'learningDisorder') return 'learning_Refer_MJMJYAndMOUY';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attention_Refer_MJMJYAndMOUY';
    if (diseaseField == 'other_ddid') return 'other_ddidMJMJYAndMOUY';
  }
  
  // Handle DEIC referrals
  if (referralField == 'DEIC') {
    if (diseaseField == 'visionImpairment') return 'vision_Refer_DEIC';
    if (diseaseField == 'hearingImpairment') return 'hearing_Refer_DEIC';
    if (diseaseField == 'neuromotorImpairment') return 'neuro_Refer_DEIC';
    if (diseaseField == 'motorDelay') return 'motor_Refer_DEIC';
    if (diseaseField == 'cognitiveDelay') return 'cognitive_Refer_DEIC';
    if (diseaseField == 'speechAndLanguageDelay') return 'speech_Refer_DEIC';
    if (diseaseField == 'behaviouralDisorder') return 'behavoiural_Refer_DEIC';
    if (diseaseField == 'learningDisorder') return 'learning_Refer_DEIC';
    if (diseaseField == 'attentionDeficitHyperactivityDisorder') return 'attention_Refer_DEIC';
    if (diseaseField == 'other_ddid') return 'other_ddidRefer_DEIC';
  }
  
  return '';
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
                '5/7',
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
              }).toList(),
            ],

            SizedBox(height: 40),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
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
                          Map<String, dynamic> combinedData = _buildOutputData();
              
                          // Debug print
                          print('Combined Data: $combinedData');
              
                          // Navigate to next page with combined data
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScreeningForAngnwadiFormSix(
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
    noteControllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }
}
