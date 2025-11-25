import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:school_test/screens/student_info_screen.dart';
import 'package:school_test/utils/api_client.dart';
import 'package:school_test/config/endpoints.dart';
import 'package:school_test/utils/error_popup.dart';

class ScreeningForClassFormEight extends StatefulWidget {
  final Map<String, dynamic> combinedData;

  const ScreeningForClassFormEight({super.key, required this.combinedData});

  @override
  State<ScreeningForClassFormEight> createState() =>
      _ScreeningForClassFormEightState();
}

class _ScreeningForClassFormEightState
    extends State<ScreeningForClassFormEight> {
  //instanciating the  Loggers

  bool _isLoading = false;

  // TextEditingController _doctorNameController = TextEditingController();
  final _doctorNameController = TextEditingController();

  /// instnace of Logger
  final _logger = Logger();
  // Location state
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _locationError;

  // Disease categories mapping with exact C# model field names
  // ✅ Corrected diseaseCategories mapping (matches backend model exactly)
  final Map<String, Map<String, dynamic>> diseaseCategories = {
    'A. Defects at Birth': {
      'parent': 'defectsAtBirth',
      'diseases': [
        {
          'key': 'neuralTubeDefects',
          'label': 'Neural Tube Defects',
          'prefix': 'neural',
        },
        {'key': 'downsSyndrome', 'label': 'Downs Syndrome', 'prefix': 'downs'},
        {
          'key': 'cleftLipAndPalate',
          'label': 'Cleft Lip and Palate',
          'prefix': 'cleft',
        },
        {
          'key': 'talipesClubFoot',
          'label': 'Talipes (club foot)',
          'prefix': 'talipse',
        },
        {
          'key': 'dvelopmentalDysplasiaOfHip',
          'label': 'Developmental Dysplasia of Hip',
          'prefix': 'hip',
        },
        {
          'key': 'congenitalCatract',
          'label': 'Congenital Cataract',
          'prefix': 'congenital',
        },
        {
          'key': 'congenitalDeafness',
          'label': 'Congenital Deafness',
          'prefix': 'deafness',
        },
        {
          'key': 'congentialHeartDisease',
          'label': 'Congenital Heart Disease',
          'prefix': 'heartDisease',
        },
        {
          'key': 'retinopathyOfPrematurity',
          'label': 'Retinopathy of Prematurity',
          'prefix': 'retinopathy',
        },
        {'key': 'other', 'label': 'Other', 'prefix': 'other'},
      ],
    },
    'B. Deficiencies': {
      'parent': 'deficiencesAtBirth',
      'diseases': [
        {'key': 'anemia', 'label': 'Anemia', 'prefix': 'anemia'},
        {
          'key': 'vitaminADef',
          'label': 'Vitamin A Deficiency',
          'prefix': 'vitaminA',
        },
        {
          'key': 'vitaminDDef',
          'label': 'Vitamin D Deficiency',
          'prefix': 'vitaminD',
        },
        {'key': 'saM_Stunting', 'label': 'SAM Stunting', 'prefix': 'sam'},
        {'key': 'goiter', 'label': 'Goiter', 'prefix': 'goiter'},
        {
          'key': 'vitaminBcomplexDef',
          'label': 'Vitamin B Complex Deficiency',
          'prefix': 'vitaminB',
        },
        {'key': 'othersSpecify', 'label': 'Others', 'prefix': 'others'},
      ],
    },
    'C. Diseases': {
      'parent': 'diseases',
      'diseases': [
        {
          'key': 'skinConditionsNotLeprosy',
          'label': 'Skin Conditions (Not Leprosy)',
          'prefix': 'skin',
        },
        {
          'key': 'otitisMedia',
          'label': 'Otitis Media',
          'prefix': 'otitisMedia',
        },
        {
          'key': 'rehumaticHeartDisease',
          'label': 'Rheumatic Heart Disease',
          'prefix': 'rehumatic',
        },
        {
          'key': 'reactiveAirwayDisease',
          'label': 'Reactive Airway Disease',
          'prefix': 'reactive',
        },
        {
          'key': 'dentalConditions',
          'label': 'Dental Conditions',
          'prefix': 'dental',
        },
        {
          'key': 'childhoodLeprosyDisease',
          'label': 'Childhood Leprosy Disease',
          'prefix': 'childhood',
        },
        {
          'key': 'childhoodTuberculosis',
          'label': 'Childhood Tuberculosis',
          'prefix': 'cTuberculosis',
        },
        {
          'key': 'childhoodTuberculosisExtraPulmonary',
          'label': 'Childhood Tuberculosis Extra Pulmonary',
          'prefix': 'cTuExtra',
        },
        {'key': 'other_disease', 'label': 'Other', 'prefix': 'other_disease'},
      ],
    },
    'D. Developmental Delay Including Disability': {
      'parent': 'developmentalDelayIncludingDisability',
      'diseases': [
        {
          'key': 'visionImpairment',
          'label': 'Vision Impairment',
          'prefix': 'vision',
        },
        {
          'key': 'hearingImpairment',
          'label': 'Hearing Impairment',
          'prefix': 'hearing',
        },
        {
          'key': 'neuromotorImpairment',
          'label': 'Neuromotor Impairment',
          'prefix': 'neuromotor',
        },
        {'key': 'motorDelay', 'label': 'Motor Delay', 'prefix': 'motor'},
        {
          'key': 'cognitiveDelay',
          'label': 'Cognitive Delay',
          'prefix': 'cognitive',
        },
        {
          'key': 'speechAndLanguageDelay',
          'label': 'Speech and Language Delay',
          'prefix': 'speech',
        },
        {
          'key': 'behaviouralDisorder',
          'label': 'Behavioural Disorder',
          'prefix': 'behavoiural',
        },
        {
          'key': 'learningDisorder',
          'label': 'Learning Disorder',
          'prefix': 'learning',
        },
        {
          'key': 'attentionDeficitHyperactivityDisorder',
          'label': 'Attention Deficit Hyperactivity Disorder',
          'prefix': 'attention',
        },
        {'key': 'other_ddid', 'label': 'Other', 'prefix': 'other_ddid'},
      ],
    },
    'E. Adolescent Specific': {
      'parent': 'adolescentSpecificQuestionnare',
      'diseases': [
        {
          'key': 'growingUpConcerns',
          'label': 'Growing Up Concerns',
          'prefix': 'growing',
        },
        {
          'key': 'substanceAbuse',
          'label': 'Substance Abuse',
          'prefix': 'substance',
        },
        {'key': 'feelDepressed', 'label': 'Feel Depressed', 'prefix': 'feel'},
        {
          'key': 'delayInMenstrualCycles',
          'label': 'Delay in Menstrual Cycles',
          'prefix': 'delay',
        },
        {
          'key': 'irregularPeriods',
          'label': 'Irregular Periods',
          'prefix': 'irregular',
        },
        {
          'key': 'painOrBurningSensationWhileUrinating',
          'label': 'Pain or Burning Sensation While Urinating',
          'prefix': 'painOrBurning',
        },
        {'key': 'discharge', 'label': 'Discharge', 'prefix': 'discharge'},
        {
          'key': 'painDuringMenstruation',
          'label': 'Pain During Menstruation',
          'prefix': 'painDuring',
        },
        {'key': 'other_asq', 'label': 'Other', 'prefix': 'other_asq'},
      ],
    },
    'F. Disability': {
      'parent': 'disibility',
      'diseases': [
        {'key': 'disibility', 'label': 'Disability', 'prefix': 'disibility'},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _logger.i(
      "Current object => "
      "ClassName: ${widget.combinedData['ClassName']}, "
      "DoctorName: $_doctorNameController, "
      "SchoolId: ${widget.combinedData['SchoolId']}, "
      "SchoolName: ${widget.combinedData['SchoolName']}, "
      "TeamId: ${widget.combinedData['DoctorId']}",
    );

    // _doctorNameController =
    //     widget.combinedData['DoctorName'] != null &&
    //         widget.combinedData['DoctorName'] != 'string'
    //     ? TextEditingController(text: widget.combinedData['DoctorName'])
    //     : TextEditingController();
    // Debug: _logger received data
    _logger.i('=== COMBINED DATA RECEIVED IN FORM 8 ===');
    _logger.i(json.encode(widget.combinedData));
    _logger.i('=== Motor Delay Debug ===');
    _logger.i('defects keys: ${widget.combinedData.keys.toList()}');

    // Automatically get location when page loads
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    super.dispose();
  }

  /// Get current location using Geolocator
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
            'Location permission denied. Please grant permission in settings.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission permanently denied. Please enable in app settings.',
        );
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      _logger.i('=== LOCATION OBTAINED ===');
      _logger.i('Latitude: ${position.latitude}');
      _logger.i('Longitude: ${position.longitude}');
      _logger.i('Accuracy: ${position.accuracy}m');
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = e.toString();
      });

      _logger.e('=== LOCATION ERROR ===');
      _logger.e(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location error: ${e.toString()}'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// Get hospital names from referral flags
  String _getReferralHospitals(String prefix, String diseaseKey) {
    List<String> hospitals = [];

    // Special case for Disability (inconsistent pattern in backend)
    if (prefix == 'disibility') {
      final hospitalMap = {
        'disibilityRefer_SKNagpur': 'SK Nagpur',
        'disibility_RH': 'RH',
        'disibility_SDH': 'SDH',
        'disibility_DH': 'DH',
        'disibility_GMC': 'GMC',
        'disibility_IGMC': 'IGMC',
        'disibility_MJMJYAndMOUY': 'MJMJY',
        'disibility_DEIC': 'DEIC',
      };

      hospitalMap.forEach((key, value) {
        if (widget.combinedData[key] == true) {
          hospitals.add(value);
        }
      });
    }
    // Special case for other_disease
    else if (prefix == 'other_disease') {
      final hospitalMap = {
        'other_diseaseRefer_SKNagpur': 'SK Nagpur',
        'other_diseaseRefer_RH': 'RH',
        'other_diseaseRefer_SDH': 'SDH',
        'other_diseaseRefer_DH': 'DH',
        'other_diseaseRefer_GMC': 'GMC',
        'other_diseaseRefer_IGMC': 'IGMC',
        'other_diseaseMJMJYAndMOUY': 'MJMJY',
        'other_diseaseRefer_DEIC': 'DEIC',
      };

      hospitalMap.forEach((key, value) {
        if (widget.combinedData[key] == true) {
          hospitals.add(value);
        }
      });
    }
    // Special case for other_ddid
    else if (prefix == 'other_ddid') {
      final hospitalMap = {
        'other_ddidRefer_SKNagpur': 'SK Nagpur',
        'other_ddidRefer_RH': 'RH',
        'other_ddidRefer_SDH': 'SDH',
        'other_ddidRefer_DH': 'DH',
        'other_ddidRefer_GMC': 'GMC',
        'other_ddidRefer_IGMC': 'IGMC',
        'other_ddidMJMJYAndMOUY': 'MJMJY',
        'other_ddidRefer_DEIC': 'DEIC',
      };

      hospitalMap.forEach((key, value) {
        if (widget.combinedData[key] == true) {
          hospitals.add(value);
        }
      });
    }
    // Special case for other_asq
    else if (prefix == 'other_asq') {
      final hospitalMap = {
        'other_asqRefer_SKNagpur': 'SK Nagpur',
        'other_asqRefer_RH': 'RH',
        'other_asqRefer_SDH': 'SDH',
        'other_asqRefer_DH': 'DH',
        'other_asqRefer_GMC': 'GMC',
        'other_asqRefer_IGMC': 'IGMC',
        'other_asqMJMJYAndMOUY': 'MJMJY',
        'other_asqRefer_DEIC': 'DEIC',
      };

      hospitalMap.forEach((key, value) {
        if (widget.combinedData[key] == true) {
          hospitals.add(value);
        }
      });
    }
    // Special case for "other" (from Defects at Birth)
    else if (diseaseKey == 'other') {
      final hospitalMap = {
        'otherRefer_SKNagpur': 'SK Nagpur',
        'other_Refer_RH': 'RH',
        'other_Refer_SDH': 'SDH',
        'other_Refer_DH': 'DH',
        'other_Refer_GMC': 'GMC',
        'other_Refer_IGMC': 'IGMC',
        'other_Refer_MJMJYAndMOUY': 'MJMJY',
        'other_Refer_DEIC': 'DEIC',
      };

      hospitalMap.forEach((key, value) {
        if (widget.combinedData[key] == true) {
          hospitals.add(value);
        }
      });
    }
    // Standard pattern for all other diseases
    else {
      final hospitalMap = {
        '${diseaseKey}Refer_SKNagpur': 'SK Nagpur',
        '${prefix}_Refer_RH': 'RH',
        '${prefix}_Refer_SDH': 'SDH',
        '${prefix}_Refer_DH': 'DH',
        '${prefix}_Refer_GMC': 'GMC',
        '${prefix}_Refer_IGMC': 'IGMC',
        '${prefix}_Refer_MJMJYAndMOUY': 'MJMJY',
        '${prefix}_Refer_DEIC': 'DEIC',
      };

      hospitalMap.forEach((key, value) {
        if (widget.combinedData[key] == true) {
          hospitals.add(value);
        }
      });
    }

    return hospitals.isNotEmpty ? hospitals.join(', ') : '';
  }

  /// Dynamically build disease summary from combinedData
  Widget _buildDiseaseSummary(Map<String, dynamic> data) {
    List<Widget> allWidgets = [];
    int diseaseCounter = 1;

    diseaseCategories.forEach((categoryName, categoryData) {
      List<Widget> categoryDiseases = [];

      for (var disease in categoryData['diseases']) {
        String diseaseKey = disease['key'];

        // Check if this disease is selected
        if (data[diseaseKey] == true) {
          String prefix = disease['prefix'];

          // Handle special cases where treated/refer fields don't follow standard pattern
          // or have typos in the model
          String treatedKey;
          String referKey;

          if (diseaseKey == 'saM_Stunting') {
            treatedKey = 'samTreated';
            referKey = 'samRefer';
          } else if (diseaseKey == 'other') {
            treatedKey = 'otherTreated';
            referKey = 'otherRefer';
          } else if (diseaseKey == 'retinopathyOfPrematurity') {
            treatedKey = 'retinopathyTreated';
            referKey = 'retinopathyRefer';
          } else if (diseaseKey == 'other_disease') {
            treatedKey = 'other_diseaseTreated';
            referKey = 'other_diseaseRefer';
          } else if (diseaseKey == 'other_ddid') {
            treatedKey = 'other_ddidTreated';
            referKey = 'other_ddidRefer';
          } else if (diseaseKey == 'other_asq') {
            treatedKey = 'other_asqTreated';
            referKey = 'other_asqRefer';
          } else if (diseaseKey == 'congenitalCatract') {
            treatedKey = 'congenitalTarget';
            referKey = 'congenitalRefer';
          } else if (diseaseKey == 'congenitalDeafness') {
            treatedKey = 'deafnessTarget';
            referKey = 'deafnessRefer';
          } else if (diseaseKey == 'congentialHeartDisease') {
            treatedKey = 'heartDiseaseTarget';
            referKey = 'heartDiseaseRefer';
          } else if (diseaseKey == 'motorDelay') {
            treatedKey = 'motorDealyTrated';
            referKey = 'motorDelayRefer';
          } else if (diseaseKey == 'cognitiveDelay') {
            treatedKey = 'cognitiveTrated';
            referKey = 'cognitiveRefer';
          } else if (diseaseKey == 'rehumaticHeartDisease') {
            treatedKey = 'rehumaticTrated';
            referKey = 'rehumaticRefer';
          } else if (diseaseKey == 'dentalConditions') {
            treatedKey = 'dentalTrated';
            referKey = 'dentalRefer';
          } else if (diseaseKey == 'skinConditionsNotLeprosy') {
            treatedKey = 'skinTrated';
            referKey = 'skinRefer';
          } else if (diseaseKey == 'vitaminADef') {
            treatedKey = 'vitaminATreated';
            referKey = 'vitaminARefer';
          } else if (diseaseKey == 'vitaminDDef') {
            treatedKey = 'vitaminDTreated';
            referKey = 'vitaminDRefer';
          } else if (diseaseKey == 'goiter') {
            treatedKey = 'goiterTreated';
            referKey = 'goiterRefer';
          } else if (diseaseKey == 'vitaminBcomplexDef') {
            treatedKey = 'vitaminBTreated';
            referKey = 'vitaminBRefer';
          } else if (diseaseKey == 'othersSpecify') {
            treatedKey = 'othersTreated';
            referKey = 'othersRefer';
          } else if (diseaseKey == 'otitisMedia') {
            treatedKey = 'otitisMediaTreated';
            referKey = 'otitisMediaRefer';
          } else if (diseaseKey == 'reactiveAirwayDisease') {
            treatedKey = 'reactiveTreated';
            referKey = 'reactiveRefer';
          } else if (diseaseKey == 'childhoodLeprosyDisease') {
            treatedKey = 'childhoodTreated';
            referKey = 'childhoodRefer';
          } else if (diseaseKey == 'childhoodTuberculosis') {
            treatedKey = 'cTuberculosisTreated';
            referKey = 'cTuberculosisRefer';
          } else if (diseaseKey == 'neuromotorImpairment') {
            treatedKey = 'neuromotorTreated';
            referKey = 'neuromotorRefer';
          } else {
            treatedKey = '${prefix}Treated';
            referKey = '${prefix}Refer';
          }

          String noteKey = '${diseaseKey}_Note';

          // Debug _logger
          _logger.d('=== Disease Display ===');
          _logger.d('Disease: $diseaseKey');
          _logger.d(
            'Treated Key: $treatedKey = ${widget.combinedData[treatedKey]}',
          );
          _logger.d('Refer Key: $referKey = ${widget.combinedData[referKey]}');

          categoryDiseases.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$diseaseCounter. ${disease['label']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Treated checkbox
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.combinedData[treatedKey] =
                                !(widget.combinedData[treatedKey] ?? false);
                            // If treated is selected, unselect refer
                            if (widget.combinedData[treatedKey] == true) {
                              widget.combinedData[referKey] = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Text(
                              'Treated  ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: Colors.white,
                              ),
                              child: widget.combinedData[treatedKey] == true
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.blue,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Refer checkbox
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.combinedData[referKey] =
                                !(widget.combinedData[referKey] ?? false);
                            // If refer is selected, unselect treated
                            if (widget.combinedData[referKey] == true) {
                              widget.combinedData[treatedKey] = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Text(
                              'Refer  ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: Colors.white,
                              ),
                              child: widget.combinedData[referKey] == true
                                  ? const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.blue,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Hospital names
                      if (widget.combinedData[referKey] == true)
                        Expanded(
                          child: Text(
                            _getReferralHospitals(prefix, diseaseKey),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Note field
                  if (widget.combinedData[treatedKey] == true ||
                      widget.combinedData[referKey] == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.combinedData[treatedKey] == true
                              ? 'Enter Treated Note'
                              : 'Enter Refer Note',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextField(
                            controller: TextEditingController(
                              text:
                                  widget.combinedData[noteKey] != null &&
                                      widget.combinedData[noteKey] != 'string'
                                  ? widget.combinedData[noteKey].toString()
                                  : '',
                            ),
                            onChanged: (value) {
                              widget.combinedData[noteKey] = value;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12),
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
          diseaseCounter++;
        }
      }

      // Add category header and diseases if any diseases exist
      if (categoryDiseases.isNotEmpty) {
        allWidgets.add(
          Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              categoryName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
        allWidgets.addAll(categoryDiseases);
      }
    });

    return allWidgets.isNotEmpty
        ? ListView(children: allWidgets)
        : const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "No diseases selected from previous forms",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
  }

  Future<void> _submitForm() async {
    if (_doctorNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter doctor name"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _locationError != null
                ? "Location unavailable: $_locationError"
                : "Getting location... Please wait",
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _getCurrentLocation,
          ),
        ),
      );

      if (!_isLoadingLocation) {
        await _getCurrentLocation();
      }
      return;
    }

    // ✅ Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Submitting form...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      setState(() => _isLoading = true);

      // Prepare payload
      Map<String, dynamic> payload = Map<String, dynamic>.from(
        widget.combinedData,
      );

      payload['TeamId'] = _toInt(widget.combinedData['TeamId']);
      payload['UserId'] = _toInt(widget.combinedData['userId']);
      payload['SchoolId'] = _toInt(widget.combinedData['SchoolId']);
      payload['ClassName'] = widget.combinedData['className'];
      payload['Latitude'] = _currentPosition!.latitude.toString();
      payload['Longitude'] = _currentPosition!.longitude.toString();

      payload.forEach((key, value) {
        if (key.endsWith('_Note')) {
          payload[key] = (value == null || value == 'string')
              ? ''
              : value.toString();
        }
      });

      payload.addAll({
        "investigationStatus": "string",
        "diagnosisStatus": "string",
        "pending": "string",
        "medicine": "string",
        "death": "string",
        "cured": "string",
        "nill": "string",
        "note": "string",
        "rH_Refer_Status": "string",
        "rH_Refer_Note_Suggestion": "string",
        "sdH_Refer_Status": "string",
        "sdH_Refer_Note_Suggestion": "string",
        "dH_Refer_Status": "string",
        "dH_Refer_Note_Suggestion": "string",
        "gmC_Refer_Status": "string",
        "gmC_Refer_Note_Suggestion": "string",
        "igmC_Refer_Status": "string",
        "igmC_Refer_Note_Suggestion": "string",
        "mjmjyAndMOUY_Refer_Status": "string",
        "mjmjyAndMOUY_Refer_Note_Suggestion": "string",
        "deiC_Refer_Status": "string",
        "deiC_Refer_Note_Suggestion": "string",
        "skNagpur_Refer_Status": "string",
        "skNagpur_Refer_Note_Suggestion": "string",
      });

      _logger.i("=== FINAL PAYLOAD ===");
      payload.forEach(
        (key, value) => _logger.i('$key => ${value.runtimeType} : $value'),
      );

      final api = ApiClient();
      final response = await api.post(
        Endpoints.addScreeningSchool,
        body: payload,
      );

      _logger.i("=== RESPONSE === $response");

      // ✅ Close loading dialog safely
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      if (response['responseCode'] == 200) {
        // ✅ Show success popup
        if (context.mounted) {
          await showErrorPopup(
            context,
            isSuccess: true,
            message: 'Form submitted successfully!',
          );
        }

        // ✅ Navigate cleanly after popup closes
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => StudentInfoScreen(
                className:
                    widget.combinedData['ClassName']?.toString() ?? 'Unknown',
                isSchool: true,
                teamName: widget.combinedData['DoctorName'],
                schoolId: widget.combinedData['SchoolId'] ?? 0,
                schoolName:
                    widget.combinedData['SchoolName']?.toString() ?? 'Unknown',
                doctorId: widget.combinedData['DoctorId'] ?? 0,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (context.mounted) {
          await showErrorPopup(
            context,
            isSuccess: false,
            message: response['responseMessage'] ?? 'Unknown error occurred.',
          );
        }
      }
    } catch (e) {
      // ✅ Close dialog before showing popup
      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

      _logger.f("Error submitting form: $e");

      if (context.mounted) {
        await showErrorPopup(
          context,
          isSuccess: false,
          message: 'Something went wrong. Please try again later.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  ///Helper function to safely convert IDs to int
  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String && value.isNotEmpty) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Screening Form",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "8/8",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Doctor Name and Location Status
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Name
                Row(
                  children: const [
                    Text(
                      "Doctor Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(" *", style: TextStyle(color: Colors.red)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _doctorNameController,
                    decoration: const InputDecoration(
                      hintText: "Enter doctor name",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Location Status Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _currentPosition != null
                        ? Colors.green[50]
                        : _locationError != null
                        ? Colors.red[50]
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _currentPosition != null
                          ? Colors.green
                          : _locationError != null
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _currentPosition != null
                            ? Icons.location_on
                            : _isLoadingLocation
                            ? Icons.location_searching
                            : Icons.location_off,
                        color: _currentPosition != null
                            ? Colors.green
                            : _locationError != null
                            ? Colors.red
                            : Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentPosition != null
                                  ? 'Location obtained'
                                  : _isLoadingLocation
                                  ? 'Getting location...'
                                  : 'Location unavailable',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: _currentPosition != null
                                    ? Colors.green[700]
                                    : _locationError != null
                                    ? Colors.red[700]
                                    : Colors.blue[700],
                              ),
                            ),
                            if (_currentPosition != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
                                'Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                            if (_locationError != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                _locationError!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (_locationError != null || _currentPosition == null)
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _isLoadingLocation
                              ? null
                              : _getCurrentLocation,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Disease summary (expanded list)
          Expanded(child: _buildDiseaseSummary(widget.combinedData)),

          // Submit button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 25),
            child: ElevatedButton(
              onPressed: _isLoadingLocation ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A5568),
                disabledBackgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _isLoadingLocation ? "Getting Location..." : "Submit",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
