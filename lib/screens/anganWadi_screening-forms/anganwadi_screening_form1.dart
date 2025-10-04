import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_test/screens/anganWadi_screening-forms/screening_for_anganwadi_form_2.dart';

class ScreeningForAnganWadiFormOne extends StatefulWidget {
  final String? schoolName;

  final int? userid;
  final int? schoolId;
  final String? className;
  const ScreeningForAnganWadiFormOne({
    Key? key,
    required this.schoolName,
    required this.userid,
    required this.schoolId,
    required this.className,
  }) : super(key: key);

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

  /// form validator key
  final _formKey = GlobalKey<FormState>();

  /// formatters
  final _aadhaarFormatter = FilteringTextInputFormatter.digitsOnly;
  final _contactFormatter = FilteringTextInputFormatter.digitsOnly;
  DateTime? selectedDate;
  String selectedGender = 'Male';
  String selectedClassification = 'SAM';
  final List<String> classificationOptions = [
    'Normal',
    'SAM',
    'MAM',
    'SUW',
    'MUW',
    'Stunted',
  ];

  //calculate age function
  int _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
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
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF2196F3),
                      ),
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
            style: const TextStyle(fontSize: 16, color: Colors.black87),
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
          style: const TextStyle(fontSize: 16, color: Colors.black87),
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
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? const Color(0xFF2196F3)
                          : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
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
    if (_formKey.currentState!.validate()) {
      // Validate DOB
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please select Date of Birth"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      int age = _calculateAge(selectedDate!);
      if (age < 0 || age > 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Age must be between 0 and 6 years for Anganwadi"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Parse numeric values
      double? weight = double.tryParse(_weightController.text);
      int? height = int.tryParse(_heightController.text);

      if (weight == null || height == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter valid numeric values"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create form data map - same structure as school
      final formData = {
        // IDs
        'SchoolId': widget.schoolId,
        'UserId': widget.userid,

        // Class flags - set anganwadi flags, all school classes false
        'anganwadi':
            widget.className!.toLowerCase().contains('anganwadi') &&
            !widget.className!.toLowerCase().contains('mini'),
        'MiniAnganwadi': widget.className!.toLowerCase().contains('mini'),
        'firstclass': false,
        'SecondClass': false,
        'ThirdClass': false,
        'FourthClass': false,
        'FifthClass': false,
        'SixthClass': false,
        'SeventhClass': false,
        'EighthClass': false,
        'NinthClass': false,
        'TenthClass': false,
        'EleventhClass': false,
        'TwelthClass': false,

        // Demographics
        'ChildName': _childNameController.text.trim(),
        'Age': age.toString(),
        'Gender': selectedGender,
        'AadhaarNo': _aadhaarController.text.trim(),
        'FathersName': _fatherNameController.text.trim(),
        'FathersContactNo': _contactController.text.trim(),

        // Measurements
        'WeightInKg': weight,
        'HeightInCm': height,

        // Weight/Height status - based on user selection
        'WeightHeightNormal': selectedClassification == 'Normal',
        'WeightHeightSAM': selectedClassification == 'SAM',
        'WeightHeightMAM': selectedClassification == 'MAM',
        'WeightHeightSUW': selectedClassification == 'SUW',
        'WeightHeightMUW': selectedClassification == 'MUW',
        'WeightHeightStunted': selectedClassification == 'Stunted',

        // Blood Pressure - not applicable for Anganwadi (young children)
        'BloodPressure': false,
        'BPNormal': false,
        'BPPrehypertension': false,
        'BPStage1HTN': false,
        'BPStage2HTN': false,

        // Vision - not applicable for Anganwadi (young children)
        'AcuityOfVision': 0.0,
        'AcuityOfLeftEye': 0.0,
        'AcuityOfRightEye': 0.0,
      };

      print("Anganwadi Form Data: $formData");

      // Navigate to next screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ScreeningForAngnwadiFormTwo(previousFormData: formData),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields!'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
