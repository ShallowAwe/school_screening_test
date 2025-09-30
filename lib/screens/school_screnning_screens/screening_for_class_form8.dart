import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:school_test/utils/api_client.dart';
import 'package:school_test/config/endpoints.dart';

class ScreeningForClassFormEight extends StatefulWidget {
  final Map<String, dynamic> combinedData;

  const ScreeningForClassFormEight({super.key, required this.combinedData});

  @override
  State<ScreeningForClassFormEight> createState() =>
      _ScreeningForClassFormEightState();
}

class _ScreeningForClassFormEightState
    extends State<ScreeningForClassFormEight> {
  final TextEditingController _doctorNameController = TextEditingController();
  
  // Location state
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _locationError;

  // Disease categories mapping with exact C# model field names
  final Map<String, Map<String, dynamic>> diseaseCategories = {
    'A. Defects at Birth': {
      'parent': 'DefectsAtBirth',
      'diseases': [
        {'key': 'NeuralTubeDefects', 'label': 'Neural Tube Defects', 'prefix': 'Neural'},
        {'key': 'DownsSyndrome', 'label': 'Downs Syndrome', 'prefix': 'Downs'},
        {'key': 'CleftLipAndPalate', 'label': 'Cleft Lip and Palate', 'prefix': 'Cleft'},
        {'key': 'TalipesClubFoot', 'label': 'Talipes Club Foot', 'prefix': 'Talipse'},
        {'key': 'DvelopmentalDysplasiaOfHip', 'label': 'Developmental Dysplasia of Hip', 'prefix': 'Hip'},
        {'key': 'CongenitalCatract', 'label': 'Congenital Cataract', 'prefix': 'Co'},
        {'key': 'CongenitalDeafness', 'label': 'Congenital Deafness', 'prefix': 'Cd'},
        {'key': 'CongentialHeartDisease', 'label': 'Congenital Heart Disease', 'prefix': 'Hd'},
        {'key': 'RetinopathyOfPrematurity', 'label': 'Retinopathy of Prematurity', 'prefix': 'Rp'},
        {'key': 'Other', 'label': 'Other', 'prefix': 'Other'},
      ]
    },
    'B. Deficiencies': {
      'parent': 'DeficiencesAtBirth',
      'diseases': [
        {'key': 'Anemia', 'label': 'Anemia', 'prefix': 'Anemia'},
        {'key': 'VitaminADef', 'label': 'Vitamin A Deficiency', 'prefix': 'VA'},
        {'key': 'VitaminDDef', 'label': 'Vitamin D Deficiency', 'prefix': 'VD'},
        {'key': 'SAM_Stunting', 'label': 'SAM Stunting', 'prefix': 'Sam'},
        {'key': 'Goiter', 'label': 'Goiter', 'prefix': 'G'},
        {'key': 'VitaminBcomplexDef', 'label': 'Vitamin B Complex Deficiency', 'prefix': 'VB'},
        {'key': 'OthersSpecify', 'label': 'Others', 'prefix': 'Ot'},
      ]
    },
    'C. Diseases': {
      'parent': 'Diseases',
      'diseases': [
        {'key': 'SkinConditionsNotLeprosy', 'label': 'Skin Conditions (Not Leprosy)', 'prefix': 'Sk'},
        {'key': 'OtitisMedia', 'label': 'Otitis Media', 'prefix': 'Otm'},
        {'key': 'RehumaticHeartDisease', 'label': 'Rheumatic Heart Disease', 'prefix': 'Re'},
        {'key': 'ReactiveAirwayDisease', 'label': 'Reactive Airway Disease', 'prefix': 'Ra'},
        {'key': 'DentalConditions', 'label': 'Dental Conditions', 'prefix': 'De'},
        {'key': 'ChildhoodLeprosyDisease', 'label': 'Childhood Leprosy Disease', 'prefix': 'Ch'},
        {'key': 'ChildhoodTuberculosis', 'label': 'Childhood Tuberculosis', 'prefix': 'CTu'},
        {'key': 'ChildhoodTuberculosisExtraPulmonary', 'label': 'Childhood Tuberculosis Extra Pulmonary', 'prefix': 'CTuExtra'},
        {'key': 'other_disease', 'label': 'Other', 'prefix': 'other_disease'},
      ]
    },
    'D. Developmental Delay Including Disability': {
      'parent': 'DevelopmentalDelayIncludingDisability',
      'diseases': [
        {'key': 'VisionImpairment', 'label': 'Vision Impairment', 'prefix': 'Vision'},
        {'key': 'HearingImpairment', 'label': 'Hearing Impairment', 'prefix': 'Hearing'},
        {'key': 'NeuromotorImpairment', 'label': 'Neuromotor Impairment', 'prefix': 'Neuro'},
        {'key': 'MotorDelay', 'label': 'Motor Delay', 'prefix': 'Motor'},
        {'key': 'CognitiveDelay', 'label': 'Cognitive Delay', 'prefix': 'Cognitive'},
        {'key': 'SpeechAndLanguageDelay', 'label': 'Speech and Language Delay', 'prefix': 'Speech'},
        {'key': 'BehaviouralDisorder', 'label': 'Behavioural Disorder', 'prefix': 'Behavoiural'},
        {'key': 'LearningDisorder', 'label': 'Learning Disorder', 'prefix': 'Learning'},
        {'key': 'AttentionDeficitHyperactivityDisorder', 'label': 'Attention Deficit Hyperactivity Disorder', 'prefix': 'Attention'},
        {'key': 'other_ddid', 'label': 'Other', 'prefix': 'other_ddid'},
      ]
    },
    'E. Adolescent Specific': {
      'parent': 'AdolescentSpecificQuestionnare',
      'diseases': [
        {'key': 'GrowingUpConcerns', 'label': 'Growing Up Concerns', 'prefix': 'Growing'},
        {'key': 'SubstanceAbuse', 'label': 'Substance Abuse', 'prefix': 'Substance'},
        {'key': 'FeelDepressed', 'label': 'Feel Depressed', 'prefix': 'Feel'},
        {'key': 'DelayInMenstrualCycles', 'label': 'Delay in Menstrual Cycles', 'prefix': 'Delay'},
        {'key': 'IrregularPeriods', 'label': 'Irregular Periods', 'prefix': 'Irregular'},
        {'key': 'PainOrBurningSensationWhileUrinating', 'label': 'Pain or Burning Sensation While Urinating', 'prefix': 'PainOrBurning'},
        {'key': 'Discharge', 'label': 'Discharge', 'prefix': 'Discharge'},
        {'key': 'PainDuringMenstruation', 'label': 'Pain During Menstruation', 'prefix': 'PainDuring'},
        {'key': 'other_asq', 'label': 'Other', 'prefix': 'other_asq'},
      ]
    },
    'F. Disability': {
      'parent': 'Disibility',
      'diseases': [
        {'key': 'Disibility', 'label': 'Disability', 'prefix': 'Disibility'},
      ]
    },
  };

  @override
  void initState() {
    super.initState();
    // Debug: Print received data
    print('=== COMBINED DATA RECEIVED IN FORM 8 ===');
    print(json.encode(widget.combinedData));
    
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
          throw Exception('Location permission denied. Please grant permission in settings.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied. Please enable in app settings.');
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
  String _getReferralHospitals(String prefix) {
    List<String> hospitals = [];
    
    final Map<String, String> hospitalMap;
    
    // Special case for Disability (has inconsistent pattern in C# model)
    if (prefix == 'Disibility') {
      hospitalMap = {
        'DisibilityRefer_SKNagpur': 'SK Nagpur',
        'Disibility_RH': 'RH',
        'Disibility_SDH': 'SDH',
        'Disibility_DH': 'DH',
        'Disibility_GMC': 'GMC',
        'Disibility_IGMC': 'IGMC',
        'Disibility_MJMJYAndMOUY': 'MJMJY',
        'Disibility_DEIC': 'DEIC',
      };
    } else {
      // Standard pattern for all other diseases
      hospitalMap = {
        '${prefix}Refer_SKNagpur': 'SK Nagpur',
        '${prefix}_Refer_RH': 'RH',
        '${prefix}_Refer_SDH': 'SDH',
        '${prefix}_Refer_DH': 'DH',
        '${prefix}_Refer_GMC': 'GMC',
        '${prefix}_Refer_IGMC': 'IGMC',
        '${prefix}_Refer_MJMJYAndMOUY': 'MJMJY',
        '${prefix}_Refer_DEIC': 'DEIC',
      };
    }

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
          String treatedKey = '${prefix}Treated';
          String referKey = '${prefix}Refer';
          String noteKey = '${diseaseKey}_Note';

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
                            widget.combinedData[treatedKey] = !(widget.combinedData[treatedKey] ?? false);
                            // If treated is selected, unselect refer
                            if (widget.combinedData[treatedKey] == true) {
                              widget.combinedData[referKey] = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Text('Treated  ', style: TextStyle(fontSize: 15)),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!, width: 2),
                                color: Colors.white,
                              ),
                              child: widget.combinedData[treatedKey] == true
                                  ? const Icon(Icons.check, size: 18, color: Colors.blue)
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
                            widget.combinedData[referKey] = !(widget.combinedData[referKey] ?? false);
                            // If refer is selected, unselect treated
                            if (widget.combinedData[referKey] == true) {
                              widget.combinedData[treatedKey] = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Text('Refer  ', style: TextStyle(fontSize: 15)),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!, width: 2),
                                color: Colors.white,
                              ),
                              child: widget.combinedData[referKey] == true
                                  ? const Icon(Icons.check, size: 18, color: Colors.blue)
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
                            _getReferralHospitals(prefix),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Note field
                  if (widget.combinedData[treatedKey] == true || widget.combinedData[referKey] == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.combinedData[treatedKey] == true ? 'Enter Treated Note' : 'Enter Refer Note',
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
                              text: widget.combinedData[noteKey] != null && 
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
          content: Text(_locationError != null 
            ? "Location unavailable: $_locationError" 
            : "Getting location... Please wait"),
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
      Map<String, dynamic> payload = Map<String, dynamic>.from(widget.combinedData);
      
      // Add the final fields from Form 8
      payload['DoctorName'] = _doctorNameController.text.trim();
      payload['Latitude'] = _currentPosition!.latitude.toString();
      payload['Longitude'] = _currentPosition!.longitude.toString();
      
      // Ensure all note fields are strings (not null or 'string')
      payload.forEach((key, value) {
        if (key.endsWith('_Note')) {
          payload[key] = (value == null || value == 'string') ? '' : value.toString();
        }
      });
      
      // Debug print
      print('=== SUBMITTING PAYLOAD ===');
      print(json.encode(payload));
      
      // Submit
      final api = ApiClient();
      await api.post(Endpoints.addScreeningSchool, body: payload);
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form submitted successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      
      // Navigate back to first page
      Navigator.of(context).popUntil((route) => route.isFirst);
      
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      
      print('=== SUBMISSION ERROR ===');
      print(e.toString());
      
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _submitForm,
          ),
        ),
      );
    }
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
        title: const Text(
          "Screening For 1st Class",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "8/8",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
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
                          color: Colors.black87),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                          onPressed: _isLoadingLocation ? null : _getCurrentLocation,
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
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isLoadingLocation ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5),
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
                  color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}