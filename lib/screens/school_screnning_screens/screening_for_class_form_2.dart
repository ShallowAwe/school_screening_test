import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:school_test/models/disease_category.dart';
import 'package:school_test/models/diseases_model.dart';
import 'package:school_test/models/hospitals_model.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form_3.dart';
import 'package:http/http.dart' as http;

class ScreeningFormScreenTwo extends StatefulWidget {
  final Map<String, dynamic> previousFormData;

  const ScreeningFormScreenTwo({super.key, required this.previousFormData});

  @override
  State<ScreeningFormScreenTwo> createState() => _ScreeningFormScreenTwoState();
}

class _ScreeningFormScreenTwoState extends State<ScreeningFormScreenTwo> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _noteControllers = {};
  bool hasDefect = false;
  late List<DiseaseCategory> diseaseCategories = [];
  final bool _isLoadingHospitals = false;
  String? _hospitalError;

  //Initializing the Logger for Logging the data
  final _logger = Logger();

  /// make a list of deseases from backend For model calss diseases whcih which will be fetched from backend by diseaseCategory id
  List<Disease> diseases = [];
  Map<int, bool> selectedDiseases = {}; // diseaseId -> selected
  Map<int, String> diseaseTreatment = {}; // diseaseId -> 'Treated'/'Refer'
  Map<int, int?> diseaseReferralHospital = {}; // diseaseId -> hospitalId
  Map<int, TextEditingController> diseaseNoteControllers = {};
  Map<String, String> defectTreatment = {};
  Map<String, String> referralOptions = {};

  List<Hospital> hospitals = [];
  String currentDeseaseCategory = '';

  @override
  void initState() {
    print(
      "Current object => "
      "ClassName: ${widget.previousFormData['ClassName']}, "
      "DoctorName: ${widget.previousFormData['DoctorName']}, "
      "SchoolId: ${widget.previousFormData['SchoolId']}, "
      "SchoolName: ${widget.previousFormData['SchoolName']}, "
      "DoctorId: ${widget.previousFormData['DoctorId']}",
    );
    fetchDiseaseCategory();
    fetchHospitals();
    super.initState();
  }

  Future<void> fetchHospitals() async {
    print('🔵 Starting fetchHospitals...');
    final url = Uri.parse(
      "https://NewAPIS.rbsknagpur.in/api/Rbsk/GetHospitals",
    );
    try {
      print('🔵 Making request to: $url');
      final response = await http.get(url);
      print('🔵 Response status code: ${response.statusCode}');
      print('🔵 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🔵 Decoded data: $data');
        print('🔵 Status field: ${data['status']}');

        if (data['success'] == true) {
          final hospitalsList = (data['data'] as List)
              .map((e) => Hospital.fromJson(e))
              .toList();
          print('🔵 Parsed ${hospitalsList.length} hospitals');

          setState(() {
            hospitals = hospitalsList;
            _logger.d("Hospitals: $hospitals");
          });
        } else {
          print('❌ Status is not success: ${data['status']}');
          _logger.e('API returned non-success status: ${data['status']}');
        }
      } else {
        print('❌ Bad status code: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        _logger.e(response.body);
      }
    } catch (e, stackTrace) {
      print('❌ Exception caught: $e');
      print('❌ Stack trace: $stackTrace');
      _logger.e('Error: $e\nStackTrace: $stackTrace');
    }
  }

  Future<void> fetchDiseaseCategory() async {
    print('🟢 Starting fetchDiseaseCategory...');
    final url = Uri.parse(
      "https://NewAPIS.rbsknagpur.in/api/Rbsk/GetDiseaseByCategoryId?categoryId=1",
    );
    try {
      print('🟢 Making request to: $url');
      final response = await http.get(url);
      print('🟢 Response status code: ${response.statusCode}');
      print('🟢 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🟢 Decoded data: $data');

        if (data['success'] == true) {
          final categoryResponse = DiseaseCategoryResponse.fromJson(
            data['data'],
          );
          print('🟢 Parsed ${categoryResponse.diseases.length} diseases');

          setState(() {
            currentDeseaseCategory = categoryResponse.categoryName;
            diseases = categoryResponse.diseases;

            // Initialize maps for each disease
            for (var disease in diseases) {
              selectedDiseases[disease.diseaseId] = false;
              diseaseTreatment[disease.diseaseId] = '';
              diseaseReferralHospital[disease.diseaseId] = null;
              diseaseNoteControllers[disease.diseaseId] =
                  TextEditingController();
            }

            _logger.d("Diseases loaded: ${diseases.length}");
            _logger.i("Current Disease Category: $currentDeseaseCategory");
          });
        }
      }
    } catch (e, stackTrace) {
      print('❌ Exception in fetchDiseaseCategory: $e');
      _logger.e('Error: $e');
    }
  }

  @override
  void dispose() {
    for (var controller in diseaseNoteControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Screening Form"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '2/8',
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
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "A.$currentDeseaseCategory",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Any visible defect at birth in the child viz Cleft Lip/Club foot/Down\'s Syndrome/Cataract etc.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('No', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: !hasDefect,
                            onChanged: (value) {
                              setState(() {
                                hasDefect = !(value ?? false);
                                if (!hasDefect) {
                                  selectedDiseases.updateAll(
                                    (key, value) => false,
                                  );
                                  defectTreatment.updateAll((key, value) => '');
                                  referralOptions.updateAll((key, value) => '');
                                }
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text('Yes', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: hasDefect,
                            onChanged: (value) {
                              setState(() {
                                hasDefect = value ?? false;
                                if (!hasDefect) {
                                  selectedDiseases.updateAll(
                                    (key, value) => false,
                                  );
                                  defectTreatment.updateAll((key, value) => '');
                                  referralOptions.updateAll((key, value) => '');
                                }
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (hasDefect) ...[
                  const SizedBox(height: 16),
                  ...diseases.asMap().entries.map((entry) {
                    int index = entry.key;
                    Disease disease = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${index + 1}. ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Expanded(
                              child: Text(
                                disease.diseaseName,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value:
                                    selectedDiseases[disease.diseaseId] ??
                                    false,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDiseases[disease.diseaseId] =
                                        value ?? false;
                                    if (!(selectedDiseases[disease.diseaseId] ??
                                        false)) {
                                      diseaseTreatment[disease.diseaseId] = '';
                                      diseaseReferralHospital[disease
                                              .diseaseId] =
                                          null;
                                      diseaseNoteControllers[disease.diseaseId]
                                          ?.clear();
                                    }
                                  });
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (selectedDiseases[disease.diseaseId] ?? false) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Treated',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value:
                                        diseaseTreatment[disease.diseaseId] ==
                                        'Treated',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value ?? false) {
                                          diseaseTreatment[disease.diseaseId] =
                                              'Treated';
                                          diseaseReferralHospital[disease
                                                  .diseaseId] =
                                              null;
                                        } else {
                                          diseaseTreatment[disease.diseaseId] =
                                              '';
                                        }
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  'Refer',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value:
                                        diseaseTreatment[disease.diseaseId] ==
                                        'Refer',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value ?? false) {
                                          diseaseTreatment[disease.diseaseId] =
                                              'Refer';
                                          _showReferralOptions(
                                            disease.diseaseId,
                                          );
                                        } else {
                                          diseaseTreatment[disease.diseaseId] =
                                              '';
                                          diseaseReferralHospital[disease
                                                  .diseaseId] =
                                              null;
                                        }
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ),
                                if (diseaseReferralHospital[disease
                                        .diseaseId] !=
                                    null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    hospitals
                                        .firstWhere(
                                          (h) =>
                                              h.hospitalId ==
                                              diseaseReferralHospital[disease
                                                  .diseaseId],
                                        )
                                        .hospitalName,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (diseaseTreatment[disease.diseaseId] == 'Refer' &&
                              diseaseReferralHospital[disease.diseaseId] !=
                                  null) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller:
                                    diseaseNoteControllers[disease.diseaseId],
                                decoration: InputDecoration(
                                  labelText: 'Enter Refer Note',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (value) {
                                  if (diseaseTreatment[disease.diseaseId] ==
                                          'Refer' &&
                                      diseaseReferralHospital[disease
                                              .diseaseId] !=
                                          null &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter refer note';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                          if (diseaseTreatment[disease.diseaseId] ==
                              'Treated') ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller:
                                    diseaseNoteControllers[disease.diseaseId],
                                decoration: InputDecoration(
                                  labelText: 'Enter Treated Note',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (value) {
                                  if (diseaseTreatment[disease.diseaseId] ==
                                          'Treated' &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter treated note';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A5F7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final combinedData = _prepareFormData();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScreeningFormScreenThree(
                                        previousFormData: combinedData,
                                      ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A5F7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReferralOptions(int diseaseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Referral Hospital',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (_isLoadingHospitals)
                  Center(child: CircularProgressIndicator())
                else if (_hospitalError != null)
                  Text(_hospitalError!, style: TextStyle(color: Colors.red))
                else if (hospitals.isEmpty)
                  Text('No hospitals available')
                else
                  ...hospitals.asMap().entries.map((entry) {
                    int index = entry.key;
                    Hospital hospital = entry.value;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          diseaseReferralHospital[diseaseId] =
                              hospital.hospitalId;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          '${index + 1}. ${hospital.hospitalName}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> _prepareFormData() {
    Map<String, dynamic> formData = Map.from(widget.previousFormData);

    formData['defectsAtBirth'] = hasDefect;
    formData['categoryId'] = 1; // DefectsAtBirth category

    // Get existing detectedDiseases or initialize empty list
    List<Map<String, dynamic>> detectedDiseases =
        List<Map<String, dynamic>>.from(formData['detectedDiseases'] ?? []);

    // Process each selected disease
    for (var disease in diseases) {
      if (selectedDiseases[disease.diseaseId] == true) {
        bool isTreated = diseaseTreatment[disease.diseaseId] == 'Treated';
        int? hospitalId = diseaseReferralHospital[disease.diseaseId];
        String notes = diseaseNoteControllers[disease.diseaseId]?.text ?? '';

        Map<String, dynamic> diseaseData = {
          'diseaseId': disease.diseaseId,
          'treatedAtScreening': isTreated,
          'detectionNotes': notes,
          'treatmentNotes': isTreated ? notes : null,
        };

        // If referred, create referral object
        if (!isTreated && hospitalId != null) {
          diseaseData['referral'] = {
            'hospitalId': hospitalId,
            'referralDate': DateTime.now().toIso8601String(),
            'referralNotes': notes,
            'treatmentDate': null,
            'treatmentNotes': null,
            'referralDiseases': [
              {'diseaseId': disease.diseaseId},
            ],
          };
        } else {
          diseaseData['referral'] = null;
        }

        detectedDiseases.add(diseaseData);
      }
    }

    formData['detectedDiseases'] = detectedDiseases;

    return formData;
  }
}
