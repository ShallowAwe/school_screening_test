import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screenign_for_class_form5.dart';

class ScreeningForClassFormFour extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const ScreeningForClassFormFour({super.key, required this.previousData});

  @override
  State<ScreeningForClassFormFour> createState() =>
      _ScreeningForClassFormFourState();
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
                }).toList(),
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

    outputData['diseases'] = hasYesDiseases;

    for (var diseaseConf in diseaseConfig) {
      String field = diseaseConf['field']!;
      String prefix = diseaseConf['prefix']!;
      String treatedField = diseaseConf['treatedField']!;
      String referField = diseaseConf['referField']!;

      // Only set to true if "Yes" is selected AND this specific disease is checked
      if (hasYesDiseases && diseases[field] == true) {
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
    // Handle SKNagpur referrals
    if (referralField == 'SKNagpur') {
      if (diseaseField == 'skinConditionsNotLeprosy')
        return 'skinRefer_SKNagpur';
      if (diseaseField == 'otitisMedia') return 'otitisMediaRefer_SKNagpur';
      if (diseaseField == 'rehumaticHeartDisease')
        return 'rehumaticRefer_SKNagpur';
      if (diseaseField == 'reactiveAirwayDisease')
        return 'reactiveRefer_SKNagpur';
      if (diseaseField == 'dentalConditions') return 'dentalRefer_SKNagpur';
      if (diseaseField == 'childhoodLeprosyDisease')
        return 'childhoodRefer_SKNagpur';
      if (diseaseField == 'childhoodTuberculosis')
        return 'cTuberculosisRefer_SKNagpur';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtraRefer_SKNagpur';
      if (diseaseField == 'other_disease') return 'other_diseaseRefer_SKNagpur';
    }

    // Handle RH referrals
    if (referralField == 'RH') {
      if (diseaseField == 'skinConditionsNotLeprosy') return 'sk_Refer_RH';
      if (diseaseField == 'otitisMedia') return 'otm_Refer_RH';
      if (diseaseField == 'rehumaticHeartDisease') return 're_Refer_RH';
      if (diseaseField == 'reactiveAirwayDisease') return 'ra_Refer_RH';
      if (diseaseField == 'dentalConditions') return 'de_Refer_RH';
      if (diseaseField == 'childhoodLeprosyDisease') return 'ch_Refer_RH';
      if (diseaseField == 'childhoodTuberculosis') return 'cTu_Refer_RH';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtra_Refer_RH';
      if (diseaseField == 'other_disease') return 'other_diseaseRefer_RH';
    }

    // Handle SDH referrals
    if (referralField == 'SDH') {
      if (diseaseField == 'skinConditionsNotLeprosy') return 'sk_Refer_SDH';
      if (diseaseField == 'otitisMedia') return 'otm_Refer_SDH';
      if (diseaseField == 'rehumaticHeartDisease') return 're_Refer_SDH';
      if (diseaseField == 'reactiveAirwayDisease') return 'ra_Refer_SDH';
      if (diseaseField == 'dentalConditions') return 'de_Refer_SDH';
      if (diseaseField == 'childhoodLeprosyDisease') return 'ch_Refer_SDH';
      if (diseaseField == 'childhoodTuberculosis') return 'cTu_Refer_SDH';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtra_Refer_SDH';
      if (diseaseField == 'other_disease') return 'other_diseaseRefer_SDH';
    }

    // Handle DH referrals
    if (referralField == 'DH') {
      if (diseaseField == 'skinConditionsNotLeprosy') return 'sk_Refer_DH';
      if (diseaseField == 'otitisMedia') return 'otm_Refer_DH';
      if (diseaseField == 'rehumaticHeartDisease') return 're_Refer_DH';
      if (diseaseField == 'reactiveAirwayDisease') return 'ra_Refer_DH';
      if (diseaseField == 'dentalConditions') return 'de_Refer_DH';
      if (diseaseField == 'childhoodLeprosyDisease') return 'ch_Refer_DH';
      if (diseaseField == 'childhoodTuberculosis') return 'cTu_Refer_DH';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtra_Refer_DH';
      if (diseaseField == 'other_disease') return 'other_diseaseRefer_DH';
    }

    // Handle GMC referrals
    if (referralField == 'GMC') {
      if (diseaseField == 'skinConditionsNotLeprosy') return 'sk_Refer_GMC';
      if (diseaseField == 'otitisMedia') return 'otm_Refer_GMC';
      if (diseaseField == 'rehumaticHeartDisease') return 're_Refer_GMC';
      if (diseaseField == 'reactiveAirwayDisease') return 'ra_Refer_GMC';
      if (diseaseField == 'dentalConditions') return 'de_Refer_GMC';
      if (diseaseField == 'childhoodLeprosyDisease') return 'ch_Refer_GMC';
      if (diseaseField == 'childhoodTuberculosis') return 'cTu_Refer_GMC';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtra_Refer_GMC';
      if (diseaseField == 'other_disease') return 'other_diseaseRefer_GMC';
    }

    // Handle IGMC referrals
    if (referralField == 'IGMC') {
      if (diseaseField == 'skinConditionsNotLeprosy') return 'sk_Refer_IGMC';
      if (diseaseField == 'otitisMedia') return 'otm_Refer_IGMC';
      if (diseaseField == 'rehumaticHeartDisease') return 're_Refer_IGMC';
      if (diseaseField == 'reactiveAirwayDisease') return 'ra_Refer_IGMC';
      if (diseaseField == 'dentalConditions') return 'de_Refer_IGMC';
      if (diseaseField == 'childhoodLeprosyDisease') return 'ch_Refer_IGMC';
      if (diseaseField == 'childhoodTuberculosis') return 'cTu_Refer_IGMC';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtra_Refer_IGMC';
      if (diseaseField == 'other_disease') return 'other_diseaseRefer_IGMC';
    }

    // Handle MJMJYAndMOUY referrals
    if (referralField == 'MJMJYAndMOUY') {
      if (diseaseField == 'skinConditionsNotLeprosy')
        return 'sk_Refer_MJMJYAndMOUY';
      if (diseaseField == 'otitisMedia') return 'otm_Refer_MJMJYAndMOUY';
      if (diseaseField == 'rehumaticHeartDisease')
        return 're_Refer_MJMJYAndMOUY';
      if (diseaseField == 'reactiveAirwayDisease')
        return 'ra_Refer_MJMJYAndMOUY';
      if (diseaseField == 'dentalConditions') return 'de_Refer_MJMJYAndMOUY';
      if (diseaseField == 'childhoodLeprosyDisease')
        return 'ch_Refer_MJMJYAndMOUY';
      if (diseaseField == 'childhoodTuberculosis')
        return 'cTu_Refer_MJMJYAndMOUY';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtra_Refer_MJMJYAndMOUY';
      if (diseaseField == 'other_disease') return 'other_diseaseMJMJYAndMOUY';
    }

    // Handle DEIC referrals
    if (referralField == 'DEIC') {
      if (diseaseField == 'skinConditionsNotLeprosy') return 'sk_Refer_DEIC';
      if (diseaseField == 'otitisMedia') return 'otm_Refer_DEIC';
      if (diseaseField == 'rehumaticHeartDisease') return 're_Refer_DEIC';
      if (diseaseField == 'reactiveAirwayDisease') return 'ra_Refer_DEIC';
      if (diseaseField == 'dentalConditions') return 'de_Refer_DEIC';
      if (diseaseField == 'childhoodLeprosyDisease') return 'ch_Refer_DEIC';
      if (diseaseField == 'childhoodTuberculosis') return 'cTu_Refer_DEIC';
      if (diseaseField == 'childhoodTuberculosisExtraPulmonary')
        return 'cTuExtra_Refer_DEIC';
      if (diseaseField == 'other_disease') return 'other_diseaseRefer_DEIC';
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
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 25),
              child: Row(
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
                          Map<String, dynamic> combinedData =
                              _buildOutputData();

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
