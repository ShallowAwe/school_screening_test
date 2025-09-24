import 'package:flutter/material.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form_1.dart';

class ScreenningSchoolScreen extends StatefulWidget {
  const ScreenningSchoolScreen({super.key});

  @override
  State<ScreenningSchoolScreen> createState() => _ScreenningSchoolScreenState();
}

class _ScreenningSchoolScreenState extends State<ScreenningSchoolScreen> {
   String? selectedDistrict;
  String? selectedTaluka;
  String? selectedVillage;
  String? selectedSchoolId;
  String? selectedClass;

  final List<String> districts = ['नागपुर', 'मुंबई', 'पुणे'];
  final List<String> talukas = ['हिंगणा', 'कामठी', 'रामटेक'];
  final List<String> villages = ['हिंगणगाव', 'कामठीगाव', 'रामटेकगाव'];
  final List<String> schoolIds = ['SCH001', 'SCH002', 'SCH003'];

  // Mock data for school information - will be replaced with API data in future
  final Map<String, Map<String, dynamic>> schoolData = {
    'SCH001': {
      'name': 'बौकसघड्ब',
      'totalStudents': 24,
      'boys': 12,
      'girls': 12,
    },
    'SCH002': {
      'name': 'श्री शिवाजी विद्यालय',
      'totalStudents': 45,
      'boys': 23,
      'girls': 22,
    },
    'SCH003': {
      'name': 'सरकारी प्राथमिक शाळा',
      'totalStudents': 38,
      'boys': 20,
      'girls': 18,
    },
  };

  final List<String> classes = [
    '1st Class', '2st Class', '3st Class',
    '4st Class', '5st Class', '6st Class',
    '7st Class', '8st Class', '9st Class',
    '10st Class', '11st Class', '12st Class'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Select School'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                    _buildRequiredLabel('District/Block'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedDistrict,
                      hint: 'Select District',
                      items: districts,
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = value;
                          // Reset dependent dropdowns
                          selectedTaluka = null;
                          selectedVillage = null;
                          selectedSchoolId = null;
                          selectedClass = null;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    _buildRequiredLabel('Taluka'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedTaluka,
                      hint: 'Select Taluka',
                      items: talukas,
                      onChanged: (value) {
                        setState(() {
                          selectedTaluka = value;
                          // Reset dependent dropdowns
                          selectedVillage = null;
                          selectedSchoolId = null;
                          selectedClass = null;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    _buildRequiredLabel('Village'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedVillage,
                      hint: 'Select Village',
                      items: villages,
                      onChanged: (value) {
                        setState(() {
                          selectedVillage = value;
                          // Reset dependent dropdown
                          selectedSchoolId = null;
                          selectedClass = null;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    _buildRequiredLabel('School ID / DISE code'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedSchoolId,
                      hint: 'Select School ID',
                      items: schoolIds,
                      onChanged: (value) {
                        setState(() {
                          selectedSchoolId = value;
                          selectedClass = null; // Reset class selection
                        });
                      },
                    ),

                    // Show school information and class selection only after school ID is selected
                    if (selectedSchoolId != null) ...[
                      const SizedBox(height: 32),
                      _buildSchoolInformation(),
                      const SizedBox(height: 24),
                      _buildClassSelection(),
                    ],
                  ],
                ),
              ),
            ),
            
            // Show Start Screening button only after school ID is selected
            if (selectedSchoolId != null)
              _buildStartScreeningButton(),
          ],
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

  Widget _buildDropdown({
    String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 56,
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
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
              ),
            ),
          ),
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.blue,
              size: 24,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSchoolInformation() {
    // TODO: Replace with API call to fetch school information
    final schoolInfo = schoolData[selectedSchoolId];
    if (schoolInfo == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'School ID / DISE code : $selectedSchoolId',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'School Name : ${schoolInfo['name']}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total No.of Students : ${schoolInfo['totalStudents']}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Boys : ${schoolInfo['boys']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 40),
              Text(
                'Girls : ${schoolInfo['girls']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Class',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement view functionality
                // Currently does nothing as requested
              },
              child: const Text(
                'View',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final className = classes[index];
            final isSelected = selectedClass == className;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedClass = className;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        className,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.blue : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStartScreeningButton() {
    final isEnabled = selectedClass != null;
    
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
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () {
                  // TODO: Navigate to screening screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (ScreeningFormScreenOne()
                        // schoolId: selectedSchoolId!,
                        // className: selectedClass!,
                        // schoolInfo: schoolData[selectedSchoolId!]!,
                      ),
                    ),
                  );
                  print('Navigate to screening with: School: $selectedSchoolId, Class: $selectedClass');
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? Colors.blue[800] : Colors.grey[400],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Start Screening',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}