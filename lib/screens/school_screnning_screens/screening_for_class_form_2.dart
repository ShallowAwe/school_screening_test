import 'package:flutter/material.dart';

class ScreeningFormScreenTwo extends StatefulWidget {
  const ScreeningFormScreenTwo({super.key});

  @override
  State<ScreeningFormScreenTwo> createState() => _ScreeningFormScreenTwoState();
}

class _ScreeningFormScreenTwoState extends State<ScreeningFormScreenTwo> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _treatedNoteControllers = {};
  bool hasDefect = true; // Changed to true to match screenshot
  Map<String, bool> defects = {
    'Neural Tube Defect': true, // Changed to true to match screenshot
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
    'RH',
    'SDH', 
    'DH',
    'GMC',
    'IGMC',
    'MJMJY & MOUY',
    'DEIC',
    'Samaj Kalyan Nagpur',
  ];

  @override
  void initState() {
    super.initState();
    defects.keys.forEach((defect) {
      defectTreatment[defect] = 'Refer';
      referralOptions[defect] = '';
      _treatedNoteControllers[defect] = TextEditingController();
    });
    // Set Neural Tube Defect to Treated to match screenshot
    defectTreatment['Neural Tube Defect'] = 'Treated';
  }

  @override
  void dispose() {
    _treatedNoteControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Screening For 4st Class'),
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
                // Fixed the layout for the main question
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
                                  defectTreatment.updateAll((key, value) => 'Refer');
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
                                  defectTreatment.updateAll((key, value) => 'Refer');
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
                            Text('${index + 1}. ', style: TextStyle(fontSize: 16)),
                            Expanded(
                              child: Text(defect, style: TextStyle(fontSize: 16)),
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
                                      defectTreatment[defect] = 'Refer';
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
                                const Text('Treated', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: defectTreatment[defect] == 'Treated',
                                    onChanged: (value) {
                                      setState(() {
                                        defectTreatment[defect] = (value ?? false) ? 'Treated' : 'Refer';
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                const Text('Refer', style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: defectTreatment[defect] == 'Refer',
                                    onChanged: (value) {
                                      setState(() {
                                        defectTreatment[defect] = (value ?? false) ? 'Refer' : 'Treated';
                                        if (defectTreatment[defect] == 'Refer') {
                                          _showReferralOptions(defect);
                                        }
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (defectTreatment[defect] == 'Refer' && referralOptions[defect]!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Referred to: ${referralOptions[defect]}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showReferralOptions(defect),
                                      child: Icon(Icons.edit, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if (defectTreatment[defect] == 'Treated') ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller: _treatedNoteControllers[defect],
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
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (defectTreatment[defect] == 'Treated' && (value == null || value.isEmpty)) {
                                    return 'Please enter a treated note';
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
                          backgroundColor: Color(0xFF4A5F7A), // Dark blue color to match screenshot
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Previous', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>Placeholder()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A5F7A), // Dark blue color to match screenshot
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Next', style: TextStyle(fontSize: 16)),
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
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
}