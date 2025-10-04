import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screenign_for_class_form5.dart';

class ScreeningForClassFormFour extends StatefulWidget {
  final Map<String, dynamic> previousData;
  
  const ScreeningForClassFormFour({
    super.key,
    required this.previousData,
  });

  @override
  State<ScreeningForClassFormFour> createState() => _ScreeningForClassFormFourState();
}

class _ScreeningForClassFormFourState extends State<ScreeningForClassFormFour> {
  // Disease configuration with API field names and prefixes
  final List<Map<String, String>> diseaseConfig = [
    {
      'display': 'Skin Conditions Not Leprosy',
      'field': 'skinConditionsNotLeprosy',
      'prefix': 'sk',
      'treatedField': 'skinTrated',
      'referField': 'skinRefer',
    },
    {
      'display': 'Otitis Media',
      'field': 'otitisMedia',
      'prefix': 'otm',
      'treatedField': 'otitisMediaTreated',
      'referField': 'otitisMediaRefer',
    },
    {
      'display': 'Rheumatic Heart Disease',
      'field': 'rehumaticHeartDisease',
      'prefix': 're',
      'treatedField': 'rehumaticTrated',
      'referField': 'rehumaticRefer',
    },
    {
      'display': 'Reactive Airway Disease',
      'field': 'reactiveAirwayDisease',
      'prefix': 'ra',
      'treatedField': 'reactiveTreated',
      'referField': 'reactiveRefer',
    },
    {
      'display': 'Dental Conditions',
      'field': 'dentalConditions',
      'prefix': 'de',
      'treatedField': 'dentalTrated',
      'referField': 'dentalRefer',
    },
    {
      'display': 'Childhood Leprosy Disease',
      'field': 'childhoodLeprosyDisease',
      'prefix': 'ch',
      'treatedField': 'childhoodTreated',
      'referField': 'childhoodRefer',
    },
    {
      'display': 'Childhood Tuberculosis',
      'field': 'childhoodTuberculosis',
      'prefix': 'cTu',
      'treatedField': 'cTuberculosisTreated',
      'referField': 'cTuberculosisRefer',
    },
    {
      'display': 'Childhood Tuberculosis (Extra Pulmonary)',
      'field': 'childhoodTuberculosisExtraPulmonary',
      'prefix': 'cTuExtra',
      'treatedField': 'cTuExtraTreated',
      'referField': 'cTuExtraRefer',
    },
    {
      'display': 'Others',
      'field': 'other_disease',
      'prefix': 'other_disease',
      'treatedField': 'other_diseaseTreated',
      'referField': 'other_diseaseRefer',
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
  
  // Add diseases flag - lowercase 'd'
  outputData['diseases'] = hasYesDiseases;
  
  // Process each disease
  for (var diseaseConf in diseaseConfig) {
    String field = diseaseConf['field']!;
    String prefix = diseaseConf['prefix']!;
    String treatedField = diseaseConf['treatedField']!;
    String referField = diseaseConf['referField']!;
    
    if (diseases[field] == true) {
      // Disease is selected
      outputData[_toCamelCase(field)] = true;
      
      // Add treatment/refer flags
      outputData[_toCamelCase(treatedField)] = treatmentOptions[field] == true;
      outputData[_toCamelCase(referField)] = treatmentOptions[field] == false;
      
      // Add referral options
      String selectedReferral = referralOptions[field] ?? '';
      
      for (var referral in referralList) {
        String referralField = referral['field']!;
        String fullReferralField = _getReferralFieldName(prefix, referralField, field);
        outputData[fullReferralField] = selectedReferral == referral['display'];
      }
      
      // Add note
      outputData['${_toCamelCase(field)}_Note'] = noteControllers[field]?.text ?? '';
    } else {
      // Disease not selected - set all to false
      outputData[_toCamelCase(field)] = false;
      outputData[_toCamelCase(treatedField)] = false;
      outputData[_toCamelCase(referField)] = false;
      
      for (var referral in referralList) {
        String referralField = referral['field']!;
        String fullReferralField = _getReferralFieldName(prefix, referralField, field);
        outputData[fullReferralField] = false;
      }
      
      outputData['${_toCamelCase(field)}_Note'] = '';
    }
  }
  
  return outputData;
}

// Rename and fix the function
String _toCamelCase(String input) {
  // Return as-is for exact matches (already in correct camelCase)
  if (input == 'skinConditionsNotLeprosy') return 'skinConditionsNotLeprosy';
  if (input == 'otitisMedia') return 'otitisMedia';
  if (input == 'rehumaticHeartDisease') return 'rehumaticHeartDisease';
  if (input == 'reactiveAirwayDisease') return 'reactiveAirwayDisease';
  if (input == 'dentalConditions') return 'dentalConditions';
  if (input == 'childhoodLeprosyDisease') return 'childhoodLeprosyDisease';
  if (input == 'childhoodTuberculosis') return 'childhoodTuberculosis';
  if (input == 'childhoodTuberculosisExtraPulmonary') return 'childhoodTuberculosisExtraPulmonary';
  if (input == 'other_disease') return 'other_disease';
  
  // Treated fields
  if (input == 'skinTrated') return 'skinTrated';
  if (input == 'otitisMediaTreated') return 'otitisMediaTreated';
  if (input == 'rehumaticTrated') return 'rehumaticTrated';
  if (input == 'reactiveTreated') return 'reactiveTreated';
  if (input == 'dentalTrated') return 'dentalTrated';
  if (input == 'childhoodTreated') return 'childhoodTreated';
  if (input == 'cTuberculosisTreated') return 'cTuberculosisTreated';
  if (input == 'cTuExtraTreated') return 'cTuExtraTreated';
  if (input == 'other_diseaseTreated') return 'other_diseaseTreated';
  
  // Refer fields
  if (input == 'skinRefer') return 'skinRefer';
  if (input == 'otitisMediaRefer') return 'otitisMediaRefer';
  if (input == 'rehumaticRefer') return 'rehumaticRefer';
  if (input == 'reactiveRefer') return 'reactiveRefer';
  if (input == 'dentalRefer') return 'dentalRefer';
  if (input == 'childhoodRefer') return 'childhoodRefer';
  if (input == 'cTuberculosisRefer') return 'cTuberculosisRefer';
  if (input == 'cTuExtraRefer') return 'cTuExtraRefer';
  if (input == 'other_diseaseRefer') return 'other_diseaseRefer';
  
  return input;
}

String _getReferralFieldName(String prefix, String referralField, String diseaseField) {
  // Pattern from C# model:
  // SKNagpur: {DiseaseName}Refer_SKNagpur (e.g., SkinRefer_SKNagpur)
  // Others: {Prefix}_Refer_{Referral} (e.g., Sk_Refer_RH)
  // Exception: MJMJYAndMOUY for other_disease becomes other_diseaseMJMJYAndMOUY
  
  if (referralField == 'SKNagpur') {
    if (prefix == 'other_disease') {
      return 'other_diseaseRefer_SKNagpur';
    }
    // Capitalize first letter for the disease name part
    String capitalizedField = diseaseField[0].toUpperCase() + diseaseField.substring(1);
    return '${capitalizedField}Refer_SKNagpur';
  } else if (referralField == 'MJMJYAndMOUY') {
    if (prefix == 'other_disease') {
      return 'other_diseaseMJMJYAndMOUY';
    }
    return '${_getPrefixForRefer(prefix)}_Refer_MJMJYAndMOUY';
  } else {
    if (prefix == 'other_disease') {
      return 'other_diseaseRefer_$referralField';
    }
    return '${_getPrefixForRefer(prefix)}_Refer_$referralField';
  }
}

String _getPrefixForRefer(String prefix) {
  // These match the C# model exactly
  if (prefix == 'sk') return 'Sk';
  if (prefix == 'otm') return 'Otm';
  if (prefix == 're') return 'Re';
  if (prefix == 'ra') return 'Ra';
  if (prefix == 'de') return 'De';
  if (prefix == 'ch') return 'Ch';
  if (prefix == 'cTu') return 'CTu';
  if (prefix == 'cTuExtra') return 'CTuExtra';
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
          //
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
                '4/8',
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
                  'C. Diseases',
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
                            builder: (context) => ScreenignForClassFormFive(
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