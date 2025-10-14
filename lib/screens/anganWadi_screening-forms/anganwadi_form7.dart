import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:school_test/config/endpoints.dart';
import 'package:school_test/screens/anganWadi_screening-forms/anganwadi_screening_form1.dart';
import 'package:school_test/screens/screening_sccreen_angnwadi.dart';
import 'package:school_test/utils/api_client.dart';
import 'package:school_test/utils/error_popup.dart';

class AnganWadiScreeningFormSeven extends StatefulWidget {
  final Map<String, dynamic> combinedData;

  const AnganWadiScreeningFormSeven({super.key, required this.combinedData});

  @override
  State<AnganWadiScreeningFormSeven> createState() =>
      _AnganWadiScreeningFormSevenState();
}

class _AnganWadiScreeningFormSevenState
    extends State<AnganWadiScreeningFormSeven> {
  final TextEditingController _doctorNameController = TextEditingController();

  /// Logger instance
  final _logger = Logger();
  // Location state
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _locationError;

  // Disease categories mapping with exact C# model field names
  // CORRECTED Disease categories mapping - matches backend model exactly
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
          'label': 'Talipes Club Foot',
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
          'prefix': 'co', // Backend uses 'co' prefix for hospital refs
        },
        {
          'key': 'congenitalDeafness',
          'label': 'Congenital Deafness',
          'prefix': 'cd', // Backend uses 'cd' prefix for hospital refs
        },
        {
          'key': 'congentialHeartDisease',
          'label': 'Congenital Heart Disease',
          'prefix': 'hd', // Backend uses 'hd' prefix for hospital refs
        },
        {
          'key': 'retinopathyOfPrematurity',
          'label': 'Retinopathy of Prematurity',
          'prefix': 'rp',
        },
        {'key': 'other', 'label': 'Other', 'prefix': 'other'},
      ],
    },
    'B. Deficiencies': {
      'parent': 'deficiencesAtBirth',
      'diseases': [
        {'key': 'anemia', 'label': 'Anemia', 'prefix': 'anemia'},
        {'key': 'vitaminADef', 'label': 'Vitamin A Deficiency', 'prefix': 'vA'},
        {'key': 'vitaminDDef', 'label': 'Vitamin D Deficiency', 'prefix': 'vD'},
        {'key': 'saM_Stunting', 'label': 'SAM Stunting', 'prefix': 'sam'},
        {'key': 'goiter', 'label': 'Goiter', 'prefix': 'g'},
        {
          'key': 'vitaminBcomplexDef',
          'label': 'Vitamin B Complex Deficiency',
          'prefix': 'vB',
        },
        {'key': 'othersSpecify', 'label': 'Others', 'prefix': 'ot'},
      ],
    },
    'C. Diseases': {
      'parent': 'diseases',
      'diseases': [
        {
          'key': 'skinConditionsNotLeprosy',
          'label': 'Skin Conditions (Not Leprosy)',
          'prefix': 'sk', // Backend uses 'sk' prefix for hospital refs
        },
        {'key': 'otitisMedia', 'label': 'Otitis Media', 'prefix': 'otm'},
        {
          'key': 'rehumaticHeartDisease',
          'label': 'Rheumatic Heart Disease',
          'prefix': 're', // Backend uses 're' prefix for hospital refs
        },
        {
          'key': 'reactiveAirwayDisease',
          'label': 'Reactive Airway Disease',
          'prefix': 'ra',
        },
        {
          'key': 'dentalConditions',
          'label': 'Dental Conditions',
          'prefix': 'de', // Backend uses 'de' prefix for hospital refs
        },
        {
          'key': 'childhoodLeprosyDisease',
          'label': 'Childhood Leprosy Disease',
          'prefix': 'ch',
        },
        {
          'key': 'childhoodTuberculosis',
          'label': 'Childhood Tuberculosis',
          'prefix': 'cTu',
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
          'prefix': 'neuro',
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
          'prefix': 'behavoiural', // Backend has typo 'behavoiural'
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
    print(json.encode(widget.combinedData));
    _doctorNameController.text = widget.combinedData['DoctorName'];
    print("DoctorId :${widget.combinedData['DoctorId']}");
    print("DoctorName :${widget.combinedData['DoctorName']}");
    // Debug: Print received data
    print('=== COMBINED DATA RECEIVED IN FORM 8 ===');

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

      print('=== LOCATION OBTAINED ===');
      print('Latitude: ${position.latitude}');
      print('Longitude: ${position.longitude}');
      print('Accuracy: ${position.accuracy}m');
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _locationError = e.toString();
      });

      print('=== LOCATION ERROR ===');
      print(e.toString());

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
  /// Get hospital names from referral flags
  /// Get hospital names from referral flags - MATCHES BACKEND MODEL
  String _getReferralHospitals(String prefix, String diseaseKey) {
    List<String> hospitals = [];

    // Map based on backend model structure
    Map<String, String> hospitalMap = {};

    // Special case for Disability (uses unique pattern)
    if (prefix == 'disibility') {
      hospitalMap = {
        'disibilityRefer_SKNagpur': 'SK Nagpur',
        'disibility_RH': 'RH',
        'disibility_SDH': 'SDH',
        'disibility_DH': 'DH',
        'disibility_GMC': 'GMC',
        'disibility_IGMC': 'IGMC',
        'disibility_MJMJYAndMOUY': 'MJMJY',
        'disibility_DEIC': 'DEIC',
      };
    }
    // Special case for other_disease
    else if (prefix == 'other_disease') {
      hospitalMap = {
        'other_diseaseRefer_SKNagpur': 'SK Nagpur',
        'other_diseaseRefer_RH': 'RH',
        'other_diseaseRefer_SDH': 'SDH',
        'other_diseaseRefer_DH': 'DH',
        'other_diseaseRefer_GMC': 'GMC',
        'other_diseaseRefer_IGMC': 'IGMC',
        'other_diseaseMJMJYAndMOUY': 'MJMJY',
        'other_diseaseRefer_DEIC': 'DEIC',
      };
    }
    // Special case for other_ddid
    else if (prefix == 'other_ddid') {
      hospitalMap = {
        'other_ddidRefer_SKNagpur': 'SK Nagpur',
        'other_ddidRefer_RH': 'RH',
        'other_ddidRefer_SDH': 'SDH',
        'other_ddidRefer_DH': 'DH',
        'other_ddidRefer_GMC': 'GMC',
        'other_ddidRefer_IGMC': 'IGMC',
        'other_ddidMJMJYAndMOUY': 'MJMJY',
        'other_ddidRefer_DEIC': 'DEIC',
      };
    }
    // Special case for other_asq
    else if (prefix == 'other_asq') {
      hospitalMap = {
        'other_asqRefer_SKNagpur': 'SK Nagpur',
        'other_asqRefer_RH': 'RH',
        'other_asqRefer_SDH': 'SDH',
        'other_asqRefer_DH': 'DH',
        'other_asqRefer_GMC': 'GMC',
        'other_asqRefer_IGMC': 'IGMC',
        'other_asqMJMJYAndMOUY': 'MJMJY',
        'other_asqRefer_DEIC': 'DEIC',
      };
    }
    // Special case for "other" (from Defects at Birth)
    else if (diseaseKey == 'other') {
      hospitalMap = {
        'otherRefer_SKNagpur': 'SK Nagpur',
        'other_Refer_RH': 'RH',
        'other_Refer_SDH': 'SDH',
        'other_Refer_DH': 'DH',
        'other_Refer_GMC': 'GMC',
        'other_Refer_IGMC': 'IGMC',
        'other_Refer_MJMJYAndMOUY': 'MJMJY',
        'other_Refer_DEIC': 'DEIC',
      };
    }
    // Special patterns from backend model
    else if (diseaseKey == 'congenitalCatract') {
      hospitalMap = {
        'congenitalRefer_SKNagpur': 'SK Nagpur',
        'co_Refer_RH': 'RH',
        'co_Refer_SDH': 'SDH',
        'co_Refer_DH': 'DH',
        'co_Refer_GMC': 'GMC',
        'co_Refer_IGMC': 'IGMC',
        'co_Refer_MJMJYAndMOUY': 'MJMJY',
        'co_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'congenitalDeafness') {
      hospitalMap = {
        'deafnessRefer_SKNagpur': 'SK Nagpur',
        'cd_Refer_RH': 'RH',
        'cd_Refer_SDH': 'SDH',
        'cd_Refer_DH': 'DH',
        'cd_Refer_GMC': 'GMC',
        'cd_Refer_IGMC': 'IGMC',
        'cd_Refer_MJMJYAndMOUY': 'MJMJY',
        'cd_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'congentialHeartDisease') {
      hospitalMap = {
        'heartDiseaseRefer_SKNagpur': 'SK Nagpur',
        'hd_Refer_RH': 'RH',
        'hd_Refer_SDH': 'SDH',
        'hd_Refer_DH': 'DH',
        'hd_Refer_GMC': 'GMC',
        'hd_Refer_IGMC': 'IGMC',
        'hd_Refer_MJMJYAndMOUY': 'MJMJY',
        'hd_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'retinopathyOfPrematurity') {
      hospitalMap = {
        'retinopathyRefer_SKNagpur': 'SK Nagpur',
        'rp_Refer_RH': 'RH',
        'rp_Refer_SDH': 'SDH',
        'rp_Refer_DH': 'DH',
        'rp_Refer_GMC': 'GMC',
        'rp_Refer_IGMC': 'IGMC',
        'rp_Refer_MJMJYAndMOUY': 'MJMJY',
        'rp_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'vitaminADef') {
      hospitalMap = {
        'vitaminARefer_SKNagpur': 'SK Nagpur',
        'vA_Refer_RH': 'RH',
        'vA_Refer_SDH': 'SDH',
        'vA_Refer_DH': 'DH',
        'vA_Refer_GMC': 'GMC',
        'vA_Refer_IGMC': 'IGMC',
        'vA_Refer_MJMJYAndMOUY': 'MJMJY',
        'vA_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'vitaminDDef') {
      hospitalMap = {
        'vitaminDRefer_SKNagpur': 'SK Nagpur',
        'vD_Refer_RH': 'RH',
        'vD_Refer_SDH': 'SDH',
        'vD_Refer_DH': 'DH',
        'vD_Refer_GMC': 'GMC',
        'vD_Refer_IGMC': 'IGMC',
        'vD_Refer_MJMJYAndMOUY': 'MJMJY',
        'vD_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'goiter') {
      hospitalMap = {
        'goiterRefer_SKNagpur': 'SK Nagpur',
        'g_Refer_RH': 'RH',
        'g_Refer_SDH': 'SDH',
        'g_Refer_DH': 'DH',
        'g_Refer_GMC': 'GMC',
        'g_Refer_IGMC': 'IGMC',
        'g_Refer_MJMJYAndMOUY': 'MJMJY',
        'g_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'vitaminBcomplexDef') {
      hospitalMap = {
        'vitaminBRefer_SKNagpur': 'SK Nagpur',
        'vB_Refer_RH': 'RH',
        'vB_Refer_SDH': 'SDH',
        'vB_Refer_DH': 'DH',
        'vB_Refer_GMC': 'GMC',
        'vB_Refer_IGMC': 'IGMC',
        'vB_Refer_MJMJYAndMOUY': 'MJMJY',
        'vB_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'othersSpecify') {
      hospitalMap = {
        'othersRefer_SKNagpur': 'SK Nagpur',
        'ot_Refer_RH': 'RH',
        'ot_Refer_SDH': 'SDH',
        'ot_Refer_DH': 'DH',
        'ot_Refer_GMC': 'GMC',
        'ot_Refer_IGMC': 'IGMC',
        'ot_Refer_MJMJYAndMOUY': 'MJMJY',
        'ot_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'skinConditionsNotLeprosy') {
      hospitalMap = {
        'skinRefer_SKNagpur': 'SK Nagpur',
        'sk_Refer_RH': 'RH',
        'sk_Refer_SDH': 'SDH',
        'sk_Refer_DH': 'DH',
        'sk_Refer_GMC': 'GMC',
        'sk_Refer_IGMC': 'IGMC',
        'sk_Refer_MJMJYAndMOUY': 'MJMJY',
        'sk_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'otitisMedia') {
      hospitalMap = {
        'otitisMediaRefer_SKNagpur': 'SK Nagpur',
        'otm_Refer_RH': 'RH',
        'otm_Refer_SDH': 'SDH',
        'otm_Refer_DH': 'DH',
        'otm_Refer_GMC': 'GMC',
        'otm_Refer_IGMC': 'IGMC',
        'otm_Refer_MJMJYAndMOUY': 'MJMJY',
        'otm_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'rehumaticHeartDisease') {
      hospitalMap = {
        'rehumaticRefer_SKNagpur': 'SK Nagpur',
        're_Refer_RH': 'RH',
        're_Refer_SDH': 'SDH',
        're_Refer_DH': 'DH',
        're_Refer_GMC': 'GMC',
        're_Refer_IGMC': 'IGMC',
        're_Refer_MJMJYAndMOUY': 'MJMJY',
        're_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'reactiveAirwayDisease') {
      hospitalMap = {
        'reactiveRefer_SKNagpur': 'SK Nagpur',
        'ra_Refer_RH': 'RH',
        'ra_Refer_SDH': 'SDH',
        'ra_Refer_DH': 'DH',
        'ra_Refer_GMC': 'GMC',
        'ra_Refer_IGMC': 'IGMC',
        'ra_Refer_MJMJYAndMOUY': 'MJMJY',
        'ra_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'dentalConditions') {
      hospitalMap = {
        'dentalRefer_SKNagpur': 'SK Nagpur',
        'de_Refer_RH': 'RH',
        'de_Refer_SDH': 'SDH',
        'de_Refer_DH': 'DH',
        'de_Refer_GMC': 'GMC',
        'de_Refer_IGMC': 'IGMC',
        'de_Refer_MJMJYAndMOUY': 'MJMJY',
        'de_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'childhoodLeprosyDisease') {
      hospitalMap = {
        'childhoodRefer_SKNagpur': 'SK Nagpur',
        'ch_Refer_RH': 'RH',
        'ch_Refer_SDH': 'SDH',
        'ch_Refer_DH': 'DH',
        'ch_Refer_GMC': 'GMC',
        'ch_Refer_IGMC': 'IGMC',
        'ch_Refer_MJMJYAndMOUY': 'MJMJY',
        'ch_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'childhoodTuberculosis') {
      hospitalMap = {
        'cTuberculosisRefer_SKNagpur': 'SK Nagpur',
        'cTu_Refer_RH': 'RH',
        'cTu_Refer_SDH': 'SDH',
        'cTu_Refer_DH': 'DH',
        'cTu_Refer_GMC': 'GMC',
        'cTu_Refer_IGMC': 'IGMC',
        'cTu_Refer_MJMJYAndMOUY': 'MJMJY',
        'cTu_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'childhoodTuberculosisExtraPulmonary') {
      hospitalMap = {
        'cTuExtraRefer_SKNagpur': 'SK Nagpur',
        'cTuExtra_Refer_RH': 'RH',
        'cTuExtra_Refer_SDH': 'SDH',
        'cTuExtra_Refer_DH': 'DH',
        'cTuExtra_Refer_GMC': 'GMC',
        'cTuExtra_Refer_IGMC': 'IGMC',
        'cTuExtra_Refer_MJMJYAndMOUY': 'MJMJY',
        'cTuExtra_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'neuromotorImpairment') {
      hospitalMap = {
        'neuromotorRefer_SKNagpur': 'SK Nagpur',
        'neuro_Refer_RH': 'RH',
        'neuro_Refer_SDH': 'SDH',
        'neuro_Refer_DH': 'DH',
        'neuro_Refer_GMC': 'GMC',
        'neuro_Refer_IGMC': 'IGMC',
        'neuro_Refer_MJMJYAndMOUY': 'MJMJY',
        'neuro_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'motorDelay') {
      hospitalMap = {
        'motorDelayRefer_SKNagpur': 'SK Nagpur',
        'motor_Refer_RH': 'RH',
        'motor_Refer_SDH': 'SDH',
        'motor_Refer_DH': 'DH',
        'motor_Refer_GMC': 'GMC',
        'motor_Refer_IGMC': 'IGMC',
        'motor_Refer_MJMJYAndMOUY': 'MJMJY',
        'motor_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'cognitiveDelay') {
      hospitalMap = {
        'cognitiveRefer_SKNagpur': 'SK Nagpur',
        'cognitive_Refer_RH': 'RH',
        'cognitive_Refer_SDH': 'SDH',
        'cognitive_Refer_DH': 'DH',
        'cognitive_Refer_GMC': 'GMC',
        'cognitive_Refer_IGMC': 'IGMC',
        'cognitive_Refer_MJMJYAndMOUY': 'MJMJY',
        'cognitive_Refer_DEIC': 'DEIC',
      };
    } else if (diseaseKey == 'behaviouralDisorder') {
      hospitalMap = {
        'behavoiuralRefer_SKNagpur': 'SK Nagpur',
        'behavoiural_Refer_RH': 'RH',
        'behavoiural_Refer_SDH': 'SDH',
        'behavoiural_Refer_DH': 'DH',
        'behavoiural_Refer_GMC': 'GMC',
        'behavoiural_Refer_IGMC': 'IGMC',
        'behavoiural_Refer_MJMJYAndMOUY': 'MJMJY',
        'behavoiural_Refer_DEIC': 'DEIC',
      };
    }
    // Standard pattern for remaining diseases
    else {
      hospitalMap = {
        '${diseaseKey}Refer_SKNagpur': 'SK Nagpur',
        '${prefix}_Refer_RH': 'RH',
        '${prefix}_Refer_SDH': 'SDH',
        '${prefix}_Refer_DH': 'DH',
        '${prefix}_Refer_GMC': 'GMC',
        '${prefix}_Refer_IGMC': 'IGMC',
        '${prefix}_Refer_MJMJYAndMOUY': 'MJMJY',
        '${prefix}_Refer_DEIC': 'DEIC',
      };
    }

    // Collect all selected hospitals
    hospitalMap.forEach((key, value) {
      if (widget.combinedData[key] == true) {
        hospitals.add(value);
      }
    });

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

          // Debug print
          print('=== Disease Display ===');
          print('Disease: $diseaseKey');
          print(
            'Treated Key: $treatedKey = ${widget.combinedData[treatedKey]}',
          );
          print('Refer Key: $referKey = ${widget.combinedData[referKey]}');

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
    // Validation - Doctor name
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

    // Validation - Location
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

      // Try to get location one more time
      if (!_isLoadingLocation) {
        await _getCurrentLocation();
      }
      return;
    }

    // Show loading dialog
    // Show loading dialog
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
      // Use combinedData directly (already has all previous form data)
      Map<String, dynamic> payload = Map<String, dynamic>.from(
        widget.combinedData,
      );

      // Add the final fields from Form 8
      payload['DoctorName'] = widget.combinedData['DoctorName'];
      payload['DoctorId'] = _toInt(widget.combinedData['DoctorId']);
      payload['UserId'] = _toInt(widget.combinedData['DoctorId']);
      payload['SchoolId'] = _toInt(widget.combinedData['SchoolId']);
      payload['ClassName'] = widget.combinedData['ClassName'];
      payload['Latitude'] = _currentPosition!.latitude.toString();
      payload['Longitude'] = _currentPosition!.longitude.toString();
      // payload.remove('userId');

      payload['Latitude'] = _currentPosition!.latitude.toString();
      payload['Longitude'] = _currentPosition!.longitude.toString();
      // Set all adolescent fields to false if not applicable
      payload['adolescentSpecificQuestionnare'] = false;
      payload['growingUpConcerns'] = false;
      payload['growingTreated'] = false;
      payload['growingRefer'] = false;
      payload['growing_Refer_RH'] = false;
      payload['growing_Refer_SDH'] = false;
      payload['growing_Refer_DH'] = false;
      payload['growing_Refer_GMC'] = false;
      payload['growing_Refer_IGMC'] = false;
      payload['growing_Refer_MJMJYAndMOUY'] = false;
      payload['growing_Refer_DEIC'] = false;
      payload['growingRefer_SKNagpur'] = false;
      payload['GrowingUpConcerns_Note'] = '';

      payload['substanceAbuse'] = false;
      payload['substanceTreated'] = false;
      payload['substanceRefer'] = false;
      payload['substance_Refer_RH'] = false;
      payload['substance_Refer_SDH'] = false;
      payload['substance_Refer_DH'] = false;
      payload['substance_Refer_GMC'] = false;
      payload['substance_Refer_IGMC'] = false;
      payload['substance_Refer_MJMJYAndMOUY'] = false;
      payload['substance_Refer_DEIC'] = false;
      payload['substanceRefer_SKNagpur'] = false;
      payload['SubstanceAbuse_Note'] = '';

      payload['feelDepressed'] = false;
      payload['feelTreated'] = false;
      payload['feelRefer'] = false;
      payload['feel_Refer_RH'] = false;
      payload['feel_Refer_SDH'] = false;
      payload['feel_Refer_DH'] = false;
      payload['feel_Refer_GMC'] = false;
      payload['feel_Refer_IGMC'] = false;
      payload['feel_Refer_MJMJYAndMOUY'] = false;
      payload['feel_Refer_DEIC'] = false;
      payload['feelRefer_SKNagpur'] = false;
      payload['FeelDepressed_Note'] = '';

      payload['delayInMenstrualCycles'] = false;
      payload['delayTreated'] = false;
      payload['delayRefer'] = false;
      payload['delay_Refer_RH'] = false;
      payload['delay_Refer_SDH'] = false;
      payload['delay_Refer_DH'] = false;
      payload['delay_Refer_GMC'] = false;
      payload['delay_Refer_IGMC'] = false;
      payload['delay_Refer_MJMJYAndMOUY'] = false;
      payload['delay_Refer_DEIC'] = false;
      payload['delayRefer_SKNagpur'] = false;
      payload['DelayInMenstrualCycles_Note'] = '';

      payload['irregularPeriods'] = false;
      payload['irregularTreated'] = false;
      payload['irregularRefer'] = false;
      payload['irregular_Refer_RH'] = false;
      payload['irregular_Refer_SDH'] = false;
      payload['irregular_Refer_DH'] = false;
      payload['irregular_Refer_GMC'] = false;
      payload['irregular_Refer_IGMC'] = false;
      payload['irregular_Refer_MJMJYAndMOUY'] = false;
      payload['irregular_Refer_DEIC'] = false;
      payload['irregularRefer_SKNagpur'] = false;
      payload['IrregularPeriods_Note'] = '';

      payload['painOrBurningSensationWhileUrinating'] = false;
      payload['painOrBurningTreated'] = false;
      payload['painOrBurningRefer'] = false;
      payload['painOrBurning_Refer_RH'] = false;
      payload['painOrBurning_Refer_SDH'] = false;
      payload['painOrBurning_Refer_DH'] = false;
      payload['painOrBurning_Refer_GMC'] = false;
      payload['painOrBurning_Refer_IGMC'] = false;
      payload['painOrBurning_Refer_MJMJYAndMOUY'] = false;
      payload['painOrBurning_Refer_DEIC'] = false;
      payload['painOrBurningRefer_SKNagpur'] = false;
      payload['PainOrBurningSensationWhileUrinating_Note'] = '';

      payload['discharge'] = false;
      payload['dischargeTreated'] = false;
      payload['dischargeRefer'] = false;
      payload['discharge_Refer_RH'] = false;
      payload['discharge_Refer_SDH'] = false;
      payload['discharge_Refer_DH'] = false;
      payload['discharge_Refer_GMC'] = false;
      payload['discharge_Refer_IGMC'] = false;
      payload['discharge_Refer_MJMJYAndMOUY'] = false;
      payload['discharge_Refer_DEIC'] = false;
      payload['dischargeRefer_SKNagpur'] = false;
      payload['Discharge_Note'] = '';

      payload['painDuringMenstruation'] = false;
      payload['painDuringTreated'] = false;
      payload['painDuringRefer'] = false;
      payload['painDuring_Refer_RH'] = false;
      payload['painDuring_Refer_SDH'] = false;
      payload['painDuring_Refer_DH'] = false;
      payload['painDuring_Refer_GMC'] = false;
      payload['painDuring_Refer_IGMC'] = false;
      payload['painDuring_Refer_MJMJYAndMOUY'] = false;
      payload['painDuring_Refer_DEIC'] = false;
      payload['painDuringRefer_SKNagpur'] = false;
      payload['PainDuringMenstruation_Note'] = '';

      payload['other_asq'] = false;
      payload['other_asqTreated'] = false;
      payload['other_asqRefer'] = false;
      payload['other_asqRefer_RH'] = false;
      payload['other_asqRefer_SDH'] = false;
      payload['other_asqRefer_DH'] = false;
      payload['other_asqRefer_GMC'] = false;
      payload['other_asqRefer_IGMC'] = false;
      payload['other_asqMJMJYAndMOUY'] = false;
      payload['other_asqRefer_DEIC'] = false;
      payload['other_asqRefer_SKNagpur'] = false;
      payload['other_asq_Note'] = '';

      // extra fields
      payload['investigationStatus'] = "string";
      payload['diagnosisStatus'] = "string";
      payload['pending'] = "string";
      payload['medicine'] = "string";
      payload['death'] = "string";
      payload['cured'] = "string";
      payload['nill'] = "string";
      payload['note'] = "string";
      payload['rH_Refer_Status'] = "string";
      payload['rH_Refer_Note_Suggestion'] = "string";
      payload['sdH_Refer_Status'] = "string";
      payload['sdH_Refer_Note_Suggestion'] = "string";
      payload['dH_Refer_Status'] = "string";
      payload['dH_Refer_Note_Suggestion'] = "string";
      payload['gmC_Refer_Status'] = "string";
      payload['gmC_Refer_Note_Suggestion'] = "string";
      payload['igmC_Refer_Status'] = "string";
      payload['igmC_Refer_Note_Suggestion'] = "string";
      payload['mjmjyAndMOUY_Refer_Status'] = "string";
      payload['mjmjyAndMOUY_Refer_Note_Suggestion'] = "string";
      payload['deiC_Refer_Status'] = "string";
      payload['deiC_Refer_Note_Suggestion'] = "string";
      payload['skNagpur_Refer_Status'] = "string";
      payload['skNagpur_Refer_Note_Suggestion'] = "string";

      //  "investigationStatus": "string",
      // "diagnosisStatus": "string",
      // "pending": "string",
      // "medicine": "string",
      // "death": "string",
      // "cured": "string",
      // "nill": "string",
      // "note": "string",
      // "rH_Refer_Status": "string",
      // "rH_Refer_Note_Suggestion": "string",
      // "sdH_Refer_Status": "string",
      // "sdH_Refer_Note_Suggestion": "string",
      // "dH_Refer_Status": "string",
      // "dH_Refer_Note_Suggestion": "string",
      // "gmC_Refer_Status": "string",
      // "gmC_Refer_Note_Suggestion": "string",
      // "igmC_Refer_Status": "string",
      // "igmC_Refer_Note_Suggestion": "string",
      // "mjmjyAndMOUY_Refer_Status": "string",
      // "mjmjyAndMOUY_Refer_Note_Suggestion": "string",
      // "deiC_Refer_Status": "string",
      // "deiC_Refer_Note_Suggestion": "string",
      // "skNagpur_Refer_Status": "string",
      // "skNagpur_Refer_Note_Suggestion": "string",

      // Ensure all note fields are strings (not null or 'string')
      payload.forEach((key, value) {
        if (key.endsWith('_Note')) {
          payload[key] = (value == null || value == 'string')
              ? ''
              : value.toString();
        }
      });

      // Debug print
      _logger.i('=== SUBMITTING PAYLOAD ===');
      _logger.i(json.encode(payload));

      // Submit
      final api = ApiClient();
      await api.post(Endpoints.addScreeningSchool, body: payload);
      payload['doctorId'] = widget.combinedData['doctorId'] ?? '';
      payload.remove('userId');

      // Close loading dialog

      // Show success message
      showErrorPopup(
        context,
        message: "Form submitted successfully!",
        isSuccess: true,
      );

      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ScreeningForAnganWadiFormOne(
              className: widget.combinedData['ClassName'],
              doctorName: widget.combinedData['DoctorName'],
              schoolId: widget.combinedData['SchoolId'],
              schoolName: widget.combinedData['SchoolName'],
              doctorId: widget.combinedData['DoctorId'],
            ),
          ),
        );
      });
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      _logger.e('=== SUBMISSION ERROR ===');
      _logger.e(e.toString());

      // Show error message with details
      String errorMessage = 'Submission failed';
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Invalid data format. Please check your entries.';
      } else {
        errorMessage = 'Submission failed: ${e.toString()}';
      }
      if (context.mounted) {
        await showErrorPopup(context, message: errorMessage, isSuccess: false);
      }
    }
  }

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
          "Screening Form ",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "7/7",
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
