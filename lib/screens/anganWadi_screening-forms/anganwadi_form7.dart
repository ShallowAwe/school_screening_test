import 'package:flutter/material.dart';

class AnganWadiScreeningFormSeven extends StatefulWidget {
  final Map<String, dynamic> previousData;

  const AnganWadiScreeningFormSeven({super.key, required this.previousData});

  @override
  State<AnganWadiScreeningFormSeven> createState() => _AnganWadiScreeningFormSevenState();
}

class _AnganWadiScreeningFormSevenState extends State<AnganWadiScreeningFormSeven> {
  // Screening condition states
  String? neuralTubeDefectStatus;
  String? anemiaStatus;
  String? skinConditionStatus;
  String? visionImpairmentStatus;
  String? disabilityStatus;

  // Note controllers for treated cases
  final TextEditingController _neuralTubeNoteController = TextEditingController();
  final TextEditingController _anemiaNoteController = TextEditingController();
  final TextEditingController _skinConditionNoteController = TextEditingController();
  final TextEditingController _visionImpairmentNoteController = TextEditingController();
  final TextEditingController _disabilityNoteController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();

  // Validation errors
  Map<String, String> validationErrors = {};

  @override
  void initState() {
    super.initState();
    // Pre-populate fields with data from previous pages
    _doctorNameController.text = widget.previousData['doctorName'] ?? 'jcvvbb';
  }

  @override
  void dispose() {
    _neuralTubeNoteController.dispose();
    _anemiaNoteController.dispose();
    _skinConditionNoteController.dispose();
    _visionImpairmentNoteController.dispose();
    _disabilityNoteController.dispose();
    _doctorNameController.dispose();
    super.dispose();
  }

  void _updateConditionStatus(String condition, String status) {
    setState(() {
      switch (condition) {
        case 'neuralTube':
          neuralTubeDefectStatus = neuralTubeDefectStatus == status ? null : status;
          if (neuralTubeDefectStatus != 'Treated') {
            _neuralTubeNoteController.clear();
          }
          break;
        case 'anemia':
          anemiaStatus = anemiaStatus == status ? null : status;
          if (anemiaStatus != 'Treated') {
            _anemiaNoteController.clear();
          }
          break;
        case 'skinCondition':
          skinConditionStatus = skinConditionStatus == status ? null : status;
          if (skinConditionStatus != 'Treated') {
            _skinConditionNoteController.clear();
          }
          break;
        case 'visionImpairment':
          visionImpairmentStatus = visionImpairmentStatus == status ? null : status;
          if (visionImpairmentStatus != 'Treated') {
            _visionImpairmentNoteController.clear();
          }
          break;
        case 'disability':
          disabilityStatus = disabilityStatus == status ? null : status;
          if (disabilityStatus != 'Treated') {
            _disabilityNoteController.clear();
          }
          break;
      }
      // Clear validation errors when user makes changes
      validationErrors.clear();
    });
  }

  bool _validateForm() {
    validationErrors.clear();

    if (neuralTubeDefectStatus == null) {
      validationErrors['neuralTube'] = 'Please select Treated or Refer for Neural Tube Defect';
    }
    if (anemiaStatus == null) {
      validationErrors['anemia'] = 'Please select Treated or Refer for Anemia';
    }
    if (skinConditionStatus == null) {
      validationErrors['skinCondition'] = 'Please select Treated or Refer for Skin Conditions';
    }
    if (visionImpairmentStatus == null) {
      validationErrors['visionImpairment'] = 'Please select Treated or Refer for Vision Impairment';
    }
    if (disabilityStatus == null) {
      validationErrors['disability'] = 'Please select Treated or Refer for Disability';
    }
    if (_doctorNameController.text.trim().isEmpty) {
      validationErrors['doctorName'] = 'Doctor Name is required';
    }

    setState(() {});
    return validationErrors.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Screening For Angan Wadi'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Center(
              child: Text(
                '7/7',
                style: TextStyle(
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Neural Tube Defect
                    _buildScreeningCondition(
                      title: '1. Neural Tube Defect',
                      condition: 'neuralTube',
                      status: neuralTubeDefectStatus,
                      noteController: _neuralTubeNoteController,
                      validationError: validationErrors['neuralTube'],
                    ),
                    const SizedBox(height: 24),

                    // Anemia
                    _buildScreeningCondition(
                      title: '1. Anemia',
                      condition: 'anemia',
                      status: anemiaStatus,
                      noteController: _anemiaNoteController,
                      validationError: validationErrors['anemia'],
                    ),
                    const SizedBox(height: 24),

                    // Skin Conditions
                    _buildScreeningCondition(
                      title: '1. Skin Conditions Not Leprosy',
                      condition: 'skinCondition',
                      status: skinConditionStatus,
                      noteController: _skinConditionNoteController,
                      validationError: validationErrors['skinCondition'],
                    ),
                    const SizedBox(height: 32),

                    // Developmental delay section
                    const Text(
                      'D. Developmental delay including disability',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Vision Impairment
                    _buildScreeningCondition(
                      title: '1. Vision Impairment',
                      condition: 'visionImpairment',
                      status: visionImpairmentStatus,
                      noteController: _visionImpairmentNoteController,
                      validationError: validationErrors['visionImpairment'],
                    ),
                    const SizedBox(height: 32),

                    // Disability section
                    const Text(
                      'E. Disability',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Disability
                    _buildScreeningCondition(
                      title: '1. Disability',
                      condition: 'disability',
                      status: disabilityStatus,
                      noteController: _disabilityNoteController,
                      validationError: validationErrors['disability'],
                    ),
                    const SizedBox(height: 32),

                    // Doctor Name Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(text: 'Doctor Name'),
                              TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: validationErrors['doctorName'] != null 
                                  ? Colors.red 
                                  : Colors.blue[300]!,
                              width: 2,
                            ),
                          ),
                          child: TextField(
                            controller: _doctorNameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            onChanged: (_) {
                              if (validationErrors['doctorName'] != null) {
                                setState(() {
                                  validationErrors.remove('doctorName');
                                });
                              }
                            },
                          ),
                        ),
                        if (validationErrors['doctorName'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              validationErrors['doctorName']!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildScreeningCondition({
    required String title,
    required String condition,
    required String? status,
    required TextEditingController noteController,
    String? validationError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        
        // Treated and Refer checkboxes
        Row(
          children: [
            _buildCheckboxOption(
              label: 'Treated',
              isSelected: status == 'Treated',
              onTap: () => _updateConditionStatus(condition, 'Treated'),
            ),
            const SizedBox(width: 32),
            _buildCheckboxOption(
              label: 'Refer',
              isSelected: status == 'Refer',
              onTap: () => _updateConditionStatus(condition, 'Refer'),
            ),
          ],
        ),

        // Show note field if Treated is selected
        if (status == 'Treated') ...[
          const SizedBox(height: 16),
          const Text(
            'Enter Treated Note',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[400]!, width: 2),
            ),
            child: TextField(
              controller: noteController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],

        // Show validation error if any
        if (validationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              validationError,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCheckboxOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.blue : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to previous screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateForm()) {
                    // Collect all form data
                    final formData = {
                      'neuralTubeDefectStatus': neuralTubeDefectStatus,
                      'neuralTubeNote': neuralTubeDefectStatus == 'Treated' ? _neuralTubeNoteController.text : null,
                      'anemiaStatus': anemiaStatus,
                      'anemiaNote': anemiaStatus == 'Treated' ? _anemiaNoteController.text : null,
                      'skinConditionStatus': skinConditionStatus,
                      'skinConditionNote': skinConditionStatus == 'Treated' ? _skinConditionNoteController.text : null,
                      'visionImpairmentStatus': visionImpairmentStatus,
                      'visionImpairmentNote': visionImpairmentStatus == 'Treated' ? _visionImpairmentNoteController.text : null,
                      'disabilityStatus': disabilityStatus,
                      'disabilityNote': disabilityStatus == 'Treated' ? _disabilityNoteController.text : null,
                      'doctorName': _doctorNameController.text.trim(),
                      'previousData': widget.previousData,
                    };

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Screening form submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    print('Form Data: $formData');

                    // TODO: Navigate to next screen or process data
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => NextScreen(data: formData),
                    //   ),
                    // );
                    
                    // For now, return data to previous screen
                    Navigator.pop(context, formData);
                  } else {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // Show validation errors
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('Please fill in all required fields'),
                    //     backgroundColor: Colors.red,
                    //   ),
                    // );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage
void main() {
  runApp(MaterialApp(
    home: AnganWadiScreeningFormSeven(
      previousData: {
        'doctorName': 'jcvvbb',
      },
    ),
  ));
}