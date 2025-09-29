import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  // Disease categories mapping
  final Map<String, Map<String, dynamic>> diseaseCategories = {
    'A. Defects at Birth': {
      'parent': 'defectsAtBirth',
      'diseases': [
        {'key': 'neuralTubeDefects', 'label': 'Neural Tube Defects', 'prefix': 'neural'},
        {'key': 'downsSyndrome', 'label': 'Downs Syndrome', 'prefix': 'downs'},
        {'key': 'cleftLipAndPalate', 'label': 'Cleft Lip and Palate', 'prefix': 'cleft'},
        {'key': 'talipesClubFoot', 'label': 'Talipes Club Foot', 'prefix': 'talipse'},
        {'key': 'dvelopmentalDysplasiaOfHip', 'label': 'Developmental Dysplasia of Hip', 'prefix': 'hip'},
        {'key': 'congenitalCatract', 'label': 'Congenital Cataract', 'prefix': 'co'},
        {'key': 'congenitalDeafness', 'label': 'Congenital Deafness', 'prefix': 'cd'},
        {'key': 'congentialHeartDisease', 'label': 'Congenital Heart Disease', 'prefix': 'hd'},
        {'key': 'retinopathyOfPrematurity', 'label': 'Retinopathy of Prematurity', 'prefix': 'rp'},
        {'key': 'other', 'label': 'Other', 'prefix': 'other'},
      ]
    },
    'B. Deficiencies': {
      'parent': 'deficiencesAtBirth',
      'diseases': [
        {'key': 'anemia', 'label': 'Anemia', 'prefix': 'anemia'},
        {'key': 'vitaminADef', 'label': 'Vitamin A Deficiency', 'prefix': 'vA'},
        {'key': 'vitaminDDef', 'label': 'Vitamin D Deficiency', 'prefix': 'vD'},
        {'key': 'saM_Stunting', 'label': 'SAM Stunting', 'prefix': 'sam'},
        {'key': 'goiter', 'label': 'Goiter', 'prefix': 'g'},
        {'key': 'vitaminBcomplexDef', 'label': 'Vitamin B Complex Deficiency', 'prefix': 'vB'},
        {'key': 'othersSpecify', 'label': 'Others', 'prefix': 'ot'},
      ]
    },
    'C. Diseases': {
      'parent': 'diseases',
      'diseases': [
        {'key': 'skinConditionsNotLeprosy', 'label': 'Skin Conditions (Not Leprosy)', 'prefix': 'sk'},
        {'key': 'otitisMedia', 'label': 'Otitis Media', 'prefix': 'otm'},
        {'key': 'rehumaticHeartDisease', 'label': 'Rheumatic Heart Disease', 'prefix': 're'},
        {'key': 'reactiveAirwayDisease', 'label': 'Reactive Airway Disease', 'prefix': 'ra'},
        {'key': 'dentalConditions', 'label': 'Dental Conditions', 'prefix': 'de'},
        {'key': 'childhoodLeprosyDisease', 'label': 'Childhood Leprosy Disease', 'prefix': 'ch'},
        {'key': 'childhoodTuberculosis', 'label': 'Childhood Tuberculosis', 'prefix': 'cTu'},
        {'key': 'childhoodTuberculosisExtraPulmonary', 'label': 'Childhood Tuberculosis Extra Pulmonary', 'prefix': 'cTuExtra'},
        {'key': 'other_disease', 'label': 'Other', 'prefix': 'other_disease'},
      ]
    },
    'D. Developmental delay including disability': {
      'parent': 'developmentalDelayIncludingDisability',
      'diseases': [
        {'key': 'visionImpairment', 'label': 'Vision Impairment', 'prefix': 'vision'},
        {'key': 'hearingImpairment', 'label': 'Hearing Impairment', 'prefix': 'hearing'},
        {'key': 'neuromotorImpairment', 'label': 'Neuromotor Impairment', 'prefix': 'neuro'},
        {'key': 'motorDelay', 'label': 'Motor Delay', 'prefix': 'motor'},
        {'key': 'cognitiveDelay', 'label': 'Cognitive Delay', 'prefix': 'cognitive'},
        {'key': 'speechAndLanguageDelay', 'label': 'Speech and Language Delay', 'prefix': 'speech'},
        {'key': 'behaviouralDisorder', 'label': 'Behavioural Disorder', 'prefix': 'behavoiural'},
        {'key': 'learningDisorder', 'label': 'Learning Disorder', 'prefix': 'learning'},
        {'key': 'attentionDeficitHyperactivityDisorder', 'label': 'Attention Deficit Hyperactivity Disorder', 'prefix': 'attention'},
        {'key': 'other_ddid', 'label': 'Other', 'prefix': 'other_ddid'},
      ]
    },
    'E. Adolescent Specific': {
      'parent': 'adolescentSpecificQuestionnare',
      'diseases': [
        {'key': 'growingUpConcerns', 'label': 'Growing Up Concerns', 'prefix': 'growing'},
        {'key': 'substanceAbuse', 'label': 'Substance Abuse', 'prefix': 'substance'},
        {'key': 'feelDepressed', 'label': 'Feel Depressed', 'prefix': 'feel'},
        {'key': 'delayInMenstrualCycles', 'label': 'Delay in Menstrual Cycles', 'prefix': 'delay'},
        {'key': 'irregularPeriods', 'label': 'Irregular Periods', 'prefix': 'irregular'},
        {'key': 'painOrBurningSensationWhileUrinating', 'label': 'Pain or Burning Sensation While Urinating', 'prefix': 'painOrBurning'},
        {'key': 'discharge', 'label': 'Discharge', 'prefix': 'discharge'},
        {'key': 'painDuringMenstruation', 'label': 'Pain During Menstruation', 'prefix': 'painDuring'},
        {'key': 'other_asq', 'label': 'Other', 'prefix': 'other_asq'},
      ]
    },
    'F. Disability': {
      'parent': 'disibility',
      'diseases': [
        {'key': 'disibility', 'label': 'Disability', 'prefix': 'disibility'},
      ]
    },
  };

  @override
  void dispose() {
    _doctorNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  /// Get hospital names from referral flags
  String _getReferralHospitals(String prefix) {
    List<String> hospitals = [];
    
    final hospitalMap = {
      '${prefix}Refer_SKNagpur': 'SK Nagpur',
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
                            style: const TextStyle(fontSize: 15),
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
        : const Center(child: Text("No diseases selected"));
  }

  Future<void> _submitForm() async {
    if (_doctorNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter doctor name"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_latitudeController.text.trim().isEmpty || _longitudeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter latitude and longitude"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Inject required fields with correct case
    widget.combinedData["DoctorName"] = _doctorNameController.text.trim();
    widget.combinedData["Latitude"] = _latitudeController.text.trim();
    widget.combinedData["Longitude"] = _longitudeController.text.trim();

    // Ensure all required note fields are present (add empty if missing)
    final requiredNotes = [
      "Other_Note",
      "Anemia_Note",
      "Goiter_Note",
      "Discharge_Note",
      "other_asq_Note",
      "Disibility_Note",
      "MotorDelay_Note",
      "other_ddid_Note",
      "OtitisMedia_Note",
      "VitaminADef_Note",
      "VitaminDDef_Note",
      "SAM_Stunting_Note"
    ];
    for (final note in requiredNotes) {
      if (!widget.combinedData.containsKey(note)) {
        widget.combinedData[note] = "";
      }
    }

    // Ensure age is a string
    if (widget.combinedData["age"] != null) {
      widget.combinedData["age"] = widget.combinedData["age"].toString();
    }

    // Wrap in screeningSchoolRequest object
    final requestBody = {
      "screeningSchoolRequest": widget.combinedData
    };

    final response = await http.post(
      Uri.parse("https://api.rbsknagpur.in/api/Rbsk/AddScreeningSchool"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form submitted successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      print('Api error ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${response.body}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Doctor Name, Latitude, Longitude
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Text(
                      "Latitude",
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
                    controller: _latitudeController,
                    decoration: const InputDecoration(
                      hintText: "Enter latitude",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Text(
                      "Longitude",
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
                    controller: _longitudeController,
                    decoration: const InputDecoration(
                      hintText: "Enter longitude",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F4A6A),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}