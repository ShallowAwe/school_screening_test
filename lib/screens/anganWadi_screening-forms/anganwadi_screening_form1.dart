import 'package:flutter/material.dart';
import 'package:school_test/screens/anganWadi_screening-forms/screening_for_anganwadi_form_2.dart';

class ScreeningForAnganWadiFormOne extends StatefulWidget {
  const ScreeningForAnganWadiFormOne({Key? key}) : super(key: key);

  @override
  State<ScreeningForAnganWadiFormOne> createState() =>
      _ScreeningForAnganWadiFormOneState();
}

class _ScreeningForAnganWadiFormOneState
    extends State<ScreeningForAnganWadiFormOne> {
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  DateTime? selectedDate;
  String selectedGender = 'Male';
  String selectedClassification = 'SAM';
  final List<String> classificationOptions = [
    'Normal',
    'SAM',
    'MAM',
    'SUW',
    'MUW',
    'Stunted'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Screening For Angan Wadi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '1/7',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Child Name
            _buildTextField(
              label: 'Child Name',
              controller: _childNameController,
              placeholder: 'Enter Child Name',
              isRequired: true,
            ),
            const SizedBox(height: 20),

            // Select Age
            _buildLabel('Select Age', isRequired: true),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                          : '15-9-2023',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF2196F3)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Gender
            _buildLabel('Gender'),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildRadioButton('Male'),
                const SizedBox(width: 40),
                _buildRadioButton('Female'),
              ],
            ),
            const SizedBox(height: 20),

            // Aadhaar No
            _buildTextField(
              label: 'Aadhaar No',
              controller: _aadhaarController,
              placeholder: 'Enter Aadhaar No',
            ),
            const SizedBox(height: 20),

            // Father/Guardian Name
            _buildTextField(
              label: 'Name of Fathers/Guardian',
              controller: _fatherNameController,
              placeholder: 'Enter Name of Fathers/Guardian',
              isRequired: true,
            ),
            const SizedBox(height: 20),

            // Parent Contact No
            _buildTextField(
              label: 'Parent Contact No',
              controller: _contactController,
              placeholder: 'Enter Parent Contact No',
              isRequired: true,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            // Weight and Height
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Weight(in kg)',
                    controller: _weightController,
                    placeholder: 'Enter Weight',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Height/Length(in cm.)',
                    controller: _heightController,
                    placeholder: 'Enter Height',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Weight/Height Classification
            _buildLabel('Weight/Height for age Classification'),
            const SizedBox(height: 12),
            _buildClassificationGrid(),
            const SizedBox(height: 40),

            // Next Button
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Next',
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
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2023, 9, 15),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired: isRequired),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFF9E9E9E),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String gender) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: gender,
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value!;
            });
          },
          activeColor: const Color(0xFF2196F3),
        ),
        Text(
          gender,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildClassificationGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: classificationOptions.map((option) {
        final bool isSelected = selectedClassification == option;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedClassification = option;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2196F3)
                    : const Color(0xFFE0E0E0),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2196F3)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2196F3)
                          : const Color(0xFF9E9E9E),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 12,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isSelected ? const Color(0xFF2196F3) : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleNext() {
    // Validate required fields

    if (_childNameController.text.isEmpty ||
        _fatherNameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ScreeningForAngnwadiFormTwo(),
            ),
          );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Please fill all required fields'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
      return;
    }

    // Print form data for debugging
    print('Form Data:');
    print('Child Name: ${_childNameController.text}');
    print(
        'Age: ${selectedDate != null ? '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}' : '15-9-2023'}');
    print('Gender: $selectedGender');
    print('Aadhaar: ${_aadhaarController.text}');
    print('Father/Guardian: ${_fatherNameController.text}');
    print('Contact: ${_contactController.text}');
    print('Weight: ${_weightController.text}');
    print('Height: ${_heightController.text}');
    print('Classification: $selectedClassification');

    // Navigate to next page or handle form submission
    // Navigator.pushNamed(context, '/screening-form-2');
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _aadhaarController.dispose();
    _fatherNameController.dispose();
    _contactController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
