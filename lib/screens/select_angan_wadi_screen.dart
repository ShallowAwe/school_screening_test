import 'package:flutter/material.dart';

class SelectAnganWadiScreen extends StatefulWidget {
  const SelectAnganWadiScreen({super.key});

  @override
  State<SelectAnganWadiScreen> createState() => _SelectAnganWadiScreenState();
}

class _SelectAnganWadiScreenState extends State<SelectAnganWadiScreen> {
  String? selectedDistrict;
  String? selectedTaluka;
  String? selectedVillage;
  String? selectedSchoolId;

  final List<String> districts = ['नागपुर', 'मुंबई', 'पुणे'];
  final List<String> talukas = ['हिंगणा', 'कामठी', 'रामटेक'];
  final List<String> villages = ['हिंगणगाव', 'कामठीगाव', 'रामटेकगाव'];
  final List<String> schoolIds = ['SCH001', 'SCH002', 'SCH003'];

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
                });
              },
            ),
            const Spacer(),
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
}