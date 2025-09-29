import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form_3.dart';

class ScreeningFormScreenTwo extends StatefulWidget {
  final Map<String, dynamic> previousFormData;
  
  const ScreeningFormScreenTwo({
    super.key,
    required this.previousFormData,
  });

  @override
  State<ScreeningFormScreenTwo> createState() => _ScreeningFormScreenTwoState();
}

class _ScreeningFormScreenTwoState extends State<ScreeningFormScreenTwo> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _noteControllers = {};
  bool hasDefect = false;
  Map<String, bool> defects = {
    'Neural Tube Defect': false,
    'Down\'s Syndrome': false,
    'Cleft Lip & Palate': false,
    'Talipes (club foot)': false,
    'Developmental Dysplasia of Hip': false,
    'Congenital Cataract': false,
    'Congenital Deafness': false,
    'Congenital Heart Disease': false,
    'Retinopathy of Prematurity': false,
    'Other': false,
  };
  Map<String, String> defectTreatment = {};
  Map<String, String> referralOptions = {};

  final List<String> referralChoices = [
    'SK Nagpur',
    'RH',
    'SDH',
    'DH',
    'GMC',
    'IGMC',
    'MJMJY & MOUY',
    'DEIC',
  ];

  @override
  void initState() {
    super.initState();
    defects.keys.forEach((defect) {
      defectTreatment[defect] = '';
      referralOptions[defect] = '';
      _noteControllers[defect] = TextEditingController();
    });
  }

  @override
  void dispose() {
    _noteControllers.values.forEach(
      (controller) => controller.dispose(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Screening For 1st Class'),
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
                  'A. Defects at Birth',
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
                                  defects.updateAll((key, value) => false);
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
                                  defects.updateAll((key, value) => false);
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
                  ...defects.keys.toList().asMap().entries.map((entry) {
                    int index = entry.key;
                    String defect = entry.value;
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
                                defect,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: defects[defect]!,
                                onChanged: (value) {
                                  setState(() {
                                    defects[defect] = value ?? false;
                                    if (!defects[defect]!) {
                                      defectTreatment[defect] = '';
                                      referralOptions[defect] = '';
                                      _noteControllers[defect]?.clear();
                                    }
                                  });
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (defects[defect]!) ...[
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
                                    value: defectTreatment[defect] == 'Treated',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value ?? false) {
                                          defectTreatment[defect] = 'Treated';
                                          referralOptions[defect] = '';
                                        } else {
                                          defectTreatment[defect] = '';
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
                                    value: defectTreatment[defect] == 'Refer',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value ?? false) {
                                          defectTreatment[defect] = 'Refer';
                                          _showReferralOptions(defect);
                                        } else {
                                          defectTreatment[defect] = '';
                                          referralOptions[defect] = '';
                                        }
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ),
                                if (referralOptions[defect]!.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    referralOptions[defect]!,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (defectTreatment[defect] == 'Refer' &&
                              referralOptions[defect]!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller: _noteControllers[defect],
                                decoration: InputDecoration(
                                  labelText: 'Enter Refer Note',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (defectTreatment[defect] == 'Refer' &&
                                      referralOptions[defect]!.isNotEmpty &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter refer note';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                          if (defectTreatment[defect] == 'Treated') ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller: _noteControllers[defect],
                                decoration: InputDecoration(
                                  labelText: 'Enter Treated Note',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (defectTreatment[defect] == 'Treated' &&
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
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReferralOptions(String defect) {
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
                  'Select Referral Option',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...referralChoices.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        referralOptions[defect] = option;
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
                        '${index + 1}. $option',
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
    
    // Neural Tube Defects
    formData['neuralTubeDefects'] = defects['Neural Tube Defect'] ?? false;
    formData['neuralTreated'] = defectTreatment['Neural Tube Defect'] == 'Treated';
    formData['neuralRefer'] = defectTreatment['Neural Tube Defect'] == 'Refer';
    formData['neuralRefer_SkNagpur'] = referralOptions['Neural Tube Defect'] == 'SK Nagpur';
    formData['neural_Refer_RH'] = referralOptions['Neural Tube Defect'] == 'RH';
    formData['neural_Refer_SDH'] = referralOptions['Neural Tube Defect'] == 'SDH';
    formData['neural_Refer_DH'] = referralOptions['Neural Tube Defect'] == 'DH';
    formData['neural_Refer_GMC'] = referralOptions['Neural Tube Defect'] == 'GMC';
    formData['neural_Refer_IGMC'] = referralOptions['Neural Tube Defect'] == 'IGMC';
    formData['neural_Refer_MJMJYAndMOUY'] = referralOptions['Neural Tube Defect'] == 'MJMJY & MOUY';
    formData['neural_Refer_DEIC'] = referralOptions['Neural Tube Defect'] == 'DEIC';
    formData['neuralTubeDefects_Note'] = _noteControllers['Neural Tube Defect']?.text ?? '';
    
    // Down's Syndrome
    formData['downsSyndrome'] = defects['Down\'s Syndrome'] ?? false;
    formData['downsTreated'] = defectTreatment['Down\'s Syndrome'] == 'Treated';
    formData['downsRefer'] = defectTreatment['Down\'s Syndrome'] == 'Refer';
    formData['downsRefer_SKNagpur'] = referralOptions['Down\'s Syndrome'] == 'SK Nagpur';
    formData['downs_Refer_RH'] = referralOptions['Down\'s Syndrome'] == 'RH';
    formData['downs_Refer_SDH'] = referralOptions['Down\'s Syndrome'] == 'SDH';
    formData['downs_Refer_DH'] = referralOptions['Down\'s Syndrome'] == 'DH';
    formData['downs_Refer_GMC'] = referralOptions['Down\'s Syndrome'] == 'GMC';
    formData['downs_Refer_IGMC'] = referralOptions['Down\'s Syndrome'] == 'IGMC';
    formData['downs_Refer_MJMJYAndMOUY'] = referralOptions['Down\'s Syndrome'] == 'MJMJY & MOUY';
    formData['downs_Refer_DEIC'] = referralOptions['Down\'s Syndrome'] == 'DEIC';
    formData['downsSyndrome_Note'] = _noteControllers['Down\'s Syndrome']?.text ?? '';
    
    // Cleft Lip & Palate
    formData['cleftLipAndPalate'] = defects['Cleft Lip & Palate'] ?? false;
    formData['cleftTreated'] = defectTreatment['Cleft Lip & Palate'] == 'Treated';
    formData['cleftRefer'] = defectTreatment['Cleft Lip & Palate'] == 'Refer';
    formData['cleftRefer_SKNagpur'] = referralOptions['Cleft Lip & Palate'] == 'SK Nagpur';
    formData['cleft_Refer_RH'] = referralOptions['Cleft Lip & Palate'] == 'RH';
    formData['cleft_Refer_SDH'] = referralOptions['Cleft Lip & Palate'] == 'SDH';
    formData['cleft_Refer_DH'] = referralOptions['Cleft Lip & Palate'] == 'DH';
    formData['cleft_Refer_GMC'] = referralOptions['Cleft Lip & Palate'] == 'GMC';
    formData['cleft_Refer_IGMC'] = referralOptions['Cleft Lip & Palate'] == 'IGMC';
    formData['cleft_Refer_MJMJYAndMOUY'] = referralOptions['Cleft Lip & Palate'] == 'MJMJY & MOUY';
    formData['cleft_Refer_DEIC'] = referralOptions['Cleft Lip & Palate'] == 'DEIC';
    formData['cleftLipAndPalate_Note'] = _noteControllers['Cleft Lip & Palate']?.text ?? '';
    
    // Talipes
    formData['talipes'] = defects['Talipes (club foot)'] ?? false;
    formData['talipesTreated'] = defectTreatment['Talipes (club foot)'] == 'Treated';
    formData['talipesRefer'] = defectTreatment['Talipes (club foot)'] == 'Refer';
    formData['talipesRefer_SKNagpur'] = referralOptions['Talipes (club foot)'] == 'SK Nagpur';
    formData['talipes_Refer_RH'] = referralOptions['Talipes (club foot)'] == 'RH';
    formData['talipes_Refer_SDH'] = referralOptions['Talipes (club foot)'] == 'SDH';
    formData['talipes_Refer_DH'] = referralOptions['Talipes (club foot)'] == 'DH';
    formData['talipes_Refer_GMC'] = referralOptions['Talipes (club foot)'] == 'GMC';
    formData['talipes_Refer_IGMC'] = referralOptions['Talipes (club foot)'] == 'IGMC';
    formData['talipes_Refer_MJMJYAndMOUY'] = referralOptions['Talipes (club foot)'] == 'MJMJY & MOUY';
    formData['talipes_Refer_DEIC'] = referralOptions['Talipes (club foot)'] == 'DEIC';
    formData['talipes_Note'] = _noteControllers['Talipes (club foot)']?.text ?? '';
    
    // Developmental Dysplasia of Hip
    formData['developmentalDysplasiaOfHip'] = defects['Developmental Dysplasia of Hip'] ?? false;
    formData['developmentalTreated'] = defectTreatment['Developmental Dysplasia of Hip'] == 'Treated';
    formData['developmentalRefer'] = defectTreatment['Developmental Dysplasia of Hip'] == 'Refer';
    formData['developmentalRefer_SKNagpur'] = referralOptions['Developmental Dysplasia of Hip'] == 'SK Nagpur';
    formData['developmental_Refer_RH'] = referralOptions['Developmental Dysplasia of Hip'] == 'RH';
    formData['developmental_Refer_SDH'] = referralOptions['Developmental Dysplasia of Hip'] == 'SDH';
    formData['developmental_Refer_DH'] = referralOptions['Developmental Dysplasia of Hip'] == 'DH';
    formData['developmental_Refer_GMC'] = referralOptions['Developmental Dysplasia of Hip'] == 'GMC';
    formData['developmental_Refer_IGMC'] = referralOptions['Developmental Dysplasia of Hip'] == 'IGMC';
    formData['developmental_Refer_MJMJYAndMOUY'] = referralOptions['Developmental Dysplasia of Hip'] == 'MJMJY & MOUY';
    formData['developmental_Refer_DEIC'] = referralOptions['Developmental Dysplasia of Hip'] == 'DEIC';
    formData['developmentalDysplasiaOfHip_Note'] = _noteControllers['Developmental Dysplasia of Hip']?.text ?? '';
    
    // Congenital Cataract
    formData['congenitalCataract'] = defects['Congenital Cataract'] ?? false;
    formData['cataractTreated'] = defectTreatment['Congenital Cataract'] == 'Treated';
    formData['cataractRefer'] = defectTreatment['Congenital Cataract'] == 'Refer';
    formData['cataractRefer_SKNagpur'] = referralOptions['Congenital Cataract'] == 'SK Nagpur';
    formData['cataract_Refer_RH'] = referralOptions['Congenital Cataract'] == 'RH';
    formData['cataract_Refer_SDH'] = referralOptions['Congenital Cataract'] == 'SDH';
    formData['cataract_Refer_DH'] = referralOptions['Congenital Cataract'] == 'DH';
    formData['cataract_Refer_GMC'] = referralOptions['Congenital Cataract'] == 'GMC';
    formData['cataract_Refer_IGMC'] = referralOptions['Congenital Cataract'] == 'IGMC';
    formData['cataract_Refer_MJMJYAndMOUY'] = referralOptions['Congenital Cataract'] == 'MJMJY & MOUY';
    formData['cataract_Refer_DEIC'] = referralOptions['Congenital Cataract'] == 'DEIC';
    formData['congenitalCataract_Note'] = _noteControllers['Congenital Cataract']?.text ?? '';
    
    // Congenital Deafness
    formData['congenitalDeafness'] = defects['Congenital Deafness'] ?? false;
    formData['deafnessTreated'] = defectTreatment['Congenital Deafness'] == 'Treated';
    formData['deafnessRefer'] = defectTreatment['Congenital Deafness'] == 'Refer';
    formData['deafnessRefer_SKNagpur'] = referralOptions['Congenital Deafness'] == 'SK Nagpur';
    formData['deafness_Refer_RH'] = referralOptions['Congenital Deafness'] == 'RH';
    formData['deafness_Refer_SDH'] = referralOptions['Congenital Deafness'] == 'SDH';
    formData['deafness_Refer_DH'] = referralOptions['Congenital Deafness'] == 'DH';
    formData['deafness_Refer_GMC'] = referralOptions['Congenital Deafness'] == 'GMC';
    formData['deafness_Refer_IGMC'] = referralOptions['Congenital Deafness'] == 'IGMC';
    formData['deafness_Refer_MJMJYAndMOUY'] = referralOptions['Congenital Deafness'] == 'MJMJY & MOUY';
    formData['deafness_Refer_DEIC'] = referralOptions['Congenital Deafness'] == 'DEIC';
    formData['congenitalDeafness_Note'] = _noteControllers['Congenital Deafness']?.text ?? '';
    
    // Congenital Heart Disease
    formData['congenitalHeartDisease'] = defects['Congenital Heart Disease'] ?? false;
    formData['heartTreated'] = defectTreatment['Congenital Heart Disease'] == 'Treated';
    formData['heartRefer'] = defectTreatment['Congenital Heart Disease'] == 'Refer';
    formData['heartRefer_SKNagpur'] = referralOptions['Congenital Heart Disease'] == 'SK Nagpur';
    formData['heart_Refer_RH'] = referralOptions['Congenital Heart Disease'] == 'RH';
    formData['heart_Refer_SDH'] = referralOptions['Congenital Heart Disease'] == 'SDH';
    formData['heart_Refer_DH'] = referralOptions['Congenital Heart Disease'] == 'DH';
    formData['heart_Refer_GMC'] = referralOptions['Congenital Heart Disease'] == 'GMC';
    formData['heart_Refer_IGMC'] = referralOptions['Congenital Heart Disease'] == 'IGMC';
    formData['heart_Refer_MJMJYAndMOUY'] = referralOptions['Congenital Heart Disease'] == 'MJMJY & MOUY';
    formData['heart_Refer_DEIC'] = referralOptions['Congenital Heart Disease'] == 'DEIC';
    formData['congenitalHeartDisease_Note'] = _noteControllers['Congenital Heart Disease']?.text ?? '';
    
    // Retinopathy of Prematurity
    formData['retinopathyOfPrematurity'] = defects['Retinopathy of Prematurity'] ?? false;
    formData['retinopathyTreated'] = defectTreatment['Retinopathy of Prematurity'] == 'Treated';
    formData['retinopathyRefer'] = defectTreatment['Retinopathy of Prematurity'] == 'Refer';
    formData['retinopathyRefer_SKNagpur'] = referralOptions['Retinopathy of Prematurity'] == 'SK Nagpur';
    formData['retinopathy_Refer_RH'] = referralOptions['Retinopathy of Prematurity'] == 'RH';
    formData['retinopathy_Refer_SDH'] = referralOptions['Retinopathy of Prematurity'] == 'SDH';
    formData['retinopathy_Refer_DH'] = referralOptions['Retinopathy of Prematurity'] == 'DH';
    formData['retinopathy_Refer_GMC'] = referralOptions['Retinopathy of Prematurity'] == 'GMC';
    formData['retinopathy_Refer_IGMC'] = referralOptions['Retinopathy of Prematurity'] == 'IGMC';
    formData['retinopathy_Refer_MJMJYAndMOUY'] = referralOptions['Retinopathy of Prematurity'] == 'MJMJY & MOUY';
    formData['retinopathy_Refer_DEIC'] = referralOptions['Retinopathy of Prematurity'] == 'DEIC';
    formData['retinopathyOfPrematurity_Note'] = _noteControllers['Retinopathy of Prematurity']?.text ?? '';
    
    // Other
    formData['otherDefects'] = defects['Other'] ?? false;
    formData['otherTreated'] = defectTreatment['Other'] == 'Treated';
    formData['otherRefer'] = defectTreatment['Other'] == 'Refer';
    formData['otherRefer_SKNagpur'] = referralOptions['Other'] == 'SK Nagpur';
    formData['other_Refer_RH'] = referralOptions['Other'] == 'RH';
    formData['other_Refer_SDH'] = referralOptions['Other'] == 'SDH';
    formData['other_Refer_DH'] = referralOptions['Other'] == 'DH';
    formData['other_Refer_GMC'] = referralOptions['Other'] == 'GMC';
    formData['other_Refer_IGMC'] = referralOptions['Other'] == 'IGMC';
    formData['other_Refer_MJMJYAndMOUY'] = referralOptions['Other'] == 'MJMJY & MOUY';
    formData['other_Refer_DEIC'] = referralOptions['Other'] == 'DEIC';
    formData['otherDefects_Note'] = _noteControllers['Other']?.text ?? '';
    
    return formData;
  }
}