  import 'package:flutter/material.dart';
  import 'package:school_test/screens/school_screnning_screens/screening_for_class_form_2.dart';

  class ScreeningFormScreenOne extends StatefulWidget {
    const ScreeningFormScreenOne({super.key});

    @override
    State<ScreeningFormScreenOne> createState() => _ScreeningFormScreenOneState();
  }

  class _ScreeningFormScreenOneState extends State<ScreeningFormScreenOne> {
    final _formKey = GlobalKey<FormState>();
    final _childNameController = TextEditingController();
    final _aadhaarController = TextEditingController();
    final _fatherNameController = TextEditingController();
    final _contactController = TextEditingController();
    final _weightController = TextEditingController();
    final _heightController = TextEditingController();
    final _leftEyeController = TextEditingController();
    final _rightEyeController = TextEditingController();

    String? selectedAge;
    String selectedGender = 'Male';
    List<bool> bloodPressureSelections = List.filled(4, false);

    final List<String> ages = ['4 years', '5 years', '6 years'];
    final List<String> bloodPressureOptions = [
      'Normal',
      'Prehypertension', 
      'Stage 1 HTN',
      'Stage 2 HTN'
    ];

    double get bmi {
      final weight = double.tryParse(_weightController.text) ?? 0;
      final heightCm = double.tryParse(_heightController.text) ?? 0;
      if (weight > 0 && heightCm > 0) {
        final heightM = heightCm / 100;
        return weight / (heightM * heightM);
      }
      return 0;
    }

    String get bmiClassification {
      final bmiValue = bmi;
      if (bmiValue == 0) return '';
      if (bmiValue < 18.5) return 'Underweight';
      if (bmiValue < 25) return 'Normal';
      if (bmiValue < 30) return 'Overweight';
      return 'Obese';
    }

    @override
    void initState() {
      super.initState();
      _weightController.addListener(_updateBMI);
      _heightController.addListener(_updateBMI);
    }

    void _updateBMI() {
      setState(() {});
    }

    @override
    void dispose() {
      _weightController.removeListener(_updateBMI);
      _heightController.removeListener(_updateBMI);
      _childNameController.dispose();
      _aadhaarController.dispose();
      _fatherNameController.dispose();
      _contactController.dispose();
      _weightController.dispose();
      _heightController.dispose();
      _leftEyeController.dispose();
      _rightEyeController.dispose();
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
                  '1/8',
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRequiredLabel('Child Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _childNameController,
                    hintText: 'Enter Child Name',
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),

                  _buildRequiredLabel('Select Age'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: selectedAge,
                    hint: 'Select Age',
                    items: ages,
                    onChanged: (value) => setState(() => selectedAge = value),
                  ),
                  if (selectedAge == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Select Age',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Male',
                        groupValue: selectedGender,
                        onChanged: (value) => setState(() => selectedGender = value!),
                        activeColor: Colors.blue,
                      ),
                      const Text('Male', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 24),
                      Radio<String>(
                        value: 'Female',
                        groupValue: selectedGender,
                        onChanged: (value) => setState(() => selectedGender = value!),
                        activeColor: Colors.blue,
                      ),
                      const Text('Female', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Aadhaar No',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _aadhaarController,
                    hintText: 'Enter Aadhaar No',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  _buildRequiredLabel('Name of Fathers/Guardian'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _fatherNameController,
                    hintText: 'Enter Name of Fathers/Guardian',
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),

                  _buildRequiredLabel('Parent Contact No'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _contactController,
                    hintText: 'Enter Parent Contact No',
                    keyboardType: TextInputType.phone,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRequiredLabel('Weight(in kg)'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _weightController,
                              hintText: 'Enter Weight',
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              isRequired: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRequiredLabel('Height(in cm.)'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _heightController,
                              hintText: 'Enter Height',
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              isRequired: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (bmi > 0) ...[
                    Text(
                      'Body Mass Index(BMI) : BMI = ${bmi.toStringAsFixed(2)} kg/m2',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BMI Classification : $bmiClassification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  Text(
                    'Blood Pressure(in mmHg)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: bloodPressureSelections[0],
                                onChanged: (bool? value) {
                                  setState(() {
                                    bloodPressureSelections[0] = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Normal', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: bloodPressureSelections[1],
                                onChanged: (bool? value) {
                                  setState(() {
                                    bloodPressureSelections[1] = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Prehypertension', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: bloodPressureSelections[2],
                                onChanged: (bool? value) {
                                  setState(() {
                                    bloodPressureSelections[2] = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Stage 1 HTN', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: bloodPressureSelections[3],
                                onChanged: (bool? value) {
                                  setState(() {
                                    bloodPressureSelections[3] = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Stage 2 HTN', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Text(
                    'Acuity of Vision (Snellen\'s Chart)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRequiredLabel('Left Eye (6ft)'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _leftEyeController,
                              hintText: 'Left Eye',
                              isRequired: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRequiredLabel('Right Eye (6ft)'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _rightEyeController,
                              hintText: 'Right Eye',
                              isRequired: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.of( context).push(
                          MaterialPageRoute(builder: (context) => const ScreeningFormScreenTwo()),
                        );
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission - navigate to next screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Form submitted successfully!')),
                          );
                        }
                       
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A5568),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildRequiredLabel(String text) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          children: [
            TextSpan(text: text),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    Widget _buildTextField({
      required TextEditingController controller,
      required String hintText,
      bool isRequired = false,
      TextInputType? keyboardType,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
        ),
      );
    }

    Widget _buildDropdown({
      String? value,
      required String hint,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                hint,
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
            isExpanded: true,
            icon: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.keyboard_arrow_down, color: Colors.blue),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(item),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      );
    }
  }