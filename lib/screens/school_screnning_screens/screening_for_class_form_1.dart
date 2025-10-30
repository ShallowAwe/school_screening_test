import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form_2.dart';

class ScreeningFormScreenOne extends StatefulWidget {
  final String schoolName;
  final String doctorName;
  final int doctorId;
  final int schoolId;
  final String className;

  final String? childName;
  final String? aadhaarNo;
  final String? fatherName;
  final String? contactNo;
  final String? dateOfBirth;

  const ScreeningFormScreenOne({
    super.key,
    required this.schoolName,
    required this.doctorId,
    required this.schoolId,
    required this.className,
    required this.doctorName,
    this.childName,
    this.aadhaarNo,
    this.fatherName,
    this.contactNo,
    this.dateOfBirth,
  });

  @override
  State<ScreeningFormScreenOne> createState() => _ScreeningFormScreenOneState();
}

class _ScreeningFormScreenOneState extends State<ScreeningFormScreenOne> {
  // Instantiating
  final _logger = Logger();

  DateTime? selectedDob;

  final _formKey = GlobalKey<FormState>();
  // Use late to initialize in initState
  late TextEditingController _childNameController;
  late TextEditingController _aadhaarController;
  late TextEditingController _fatherNameController;
  late TextEditingController _contactController;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _leftEyeController = TextEditingController();
  final _rightEyeController = TextEditingController();

  ///input formatters
  final _aadhaarFormatter = FilteringTextInputFormatter.digitsOnly;
  final _contactFormatter = FilteringTextInputFormatter.digitsOnly;
  final _eyeFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*\.?\d*'),
  );

  String? selectedAge;
  String selectedGender = 'Male';
  List<bool> bloodPressureSelections = List.filled(4, false);

  final List<String> ages = ['4 years', '5 years', '6 years'];
  final List<String> bloodPressureOptions = [
    'Normal',
    'Prehypertension',
    'Stage 1 HTN',
    'Stage 2 HTN',
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

    // Initialize controllers with data from widget (previous page)
    _childNameController = TextEditingController(text: widget.childName ?? '');
    _aadhaarController = TextEditingController(text: widget.aadhaarNo ?? '');
    _fatherNameController = TextEditingController(
      text: widget.fatherName ?? '',
    );
    _contactController = TextEditingController(text: widget.contactNo ?? '');

    // Set the date of birth if provided
    if (widget.dateOfBirth != null) {
      try {
        // Parse the date string to DateTime
        // Adjust the format based on your date string format
        // Example formats:
        // "2020-05-15" use: DateTime.parse(widget.dateOfBirth!)
        // "15/05/2020" use: DateFormat('dd/MM/yyyy').parse(widget.dateOfBirth!)

        selectedDob = DateTime.parse(
          widget.dateOfBirth!,
        ); // For "yyyy-MM-dd" format

        // OR if your date is in "dd/MM/yyyy" format, uncomment below and import intl package:
        // selectedDob = DateFormat('dd/MM/yyyy').parse(widget.dateOfBirth!);
      } catch (e) {
        _logger.e("Error parsing date: $e");
        selectedDob = null;
      }
    }

    _weightController.addListener(_updateBMI);
    _heightController.addListener(_updateBMI);

    _logger.i(
      "Current object page 1=> "
      "ClassName: ${widget.className}, "
      "DoctorName: ${widget.doctorName}, "
      "SchoolId: ${widget.schoolId}, "
      "SchoolName: ${widget.schoolName}, "
      "TeamId: ${widget.doctorId}",
    );
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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Screening For ${widget.className}'),
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

                const SizedBox(height: 8),
                _buildRequiredLabel('Date of Birth'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 365 * 5),
                      ),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365 * 20),
                      ),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDob = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDob == null
                              ? 'Select Date of Birth'
                              : '${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}',
                          style: TextStyle(
                            color: selectedDob == null
                                ? Colors.grey[500]
                                : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                if (selectedDob != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Age: ${_calculateAge(selectedDob!)} years",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
                      onChanged: (value) =>
                          setState(() => selectedGender = value!),
                      activeColor: Colors.blue,
                    ),
                    const Text('Male', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 24),
                    Radio<String>(
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (value) =>
                          setState(() => selectedGender = value!),
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
                  inputFormatters: [_aadhaarFormatter],
                  maxLength: 12,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length != 12) {
                      return 'Aadhaar must be exactly 12 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildRequiredLabel('Name of Father/Guardian'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _fatherNameController,
                  hintText: 'Enter Name of Father/Guardian',
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
                  inputFormatters: [_contactFormatter],
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.length != 10) {
                      return 'Contact number must be exactly 10 digits';
                    }
                    return null;
                  },
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
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
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
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
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
                                  bloodPressureSelections = List.filled(
                                    4,
                                    false,
                                  );
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
                                  bloodPressureSelections = List.filled(
                                    4,
                                    false,
                                  );
                                  bloodPressureSelections[1] = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Prehypertension',
                            style: TextStyle(fontSize: 16),
                          ),
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
                                  bloodPressureSelections = List.filled(
                                    4,
                                    false,
                                  );
                                  bloodPressureSelections[2] = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Stage 1 HTN',
                            style: TextStyle(fontSize: 16),
                          ),
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
                                  bloodPressureSelections = List.filled(
                                    4,
                                    false,
                                  );
                                  bloodPressureSelections[3] = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Stage 2 HTN',
                            style: TextStyle(fontSize: 16),
                          ),
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
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [_eyeFormatter],
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
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [_eyeFormatter],
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
                      if (_formKey.currentState!.validate()) {
                        // Validate DOB
                        if (selectedDob == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select Date of Birth"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        int age = _calculateAge(selectedDob!);
                        if (age < 4 || age > 18) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Age must be between 4 and 18 years",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Validate Blood Pressure
                        bool hasSelectedBP = bloodPressureSelections.contains(
                          true,
                        );
                        if (!hasSelectedBP) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select Blood Pressure"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Parse numeric values with validation
                        double? weight = double.tryParse(
                          _weightController.text,
                        );
                        int? height = int.tryParse(_heightController.text);
                        double? leftEye = double.tryParse(
                          _leftEyeController.text,
                        );
                        double? rightEye = double.tryParse(
                          _rightEyeController.text,
                        );

                        if (weight == null ||
                            height == null ||
                            leftEye == null ||
                            rightEye == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter valid numeric values",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        _logger.i("School Name: ${widget.schoolName}");
                        _logger.i("Doctor Name: ${widget.doctorName}");
                        _logger.i("Doctor ID: ${widget.doctorId}");
                        _logger.i("School ID: ${widget.schoolId}");
                        _logger.i("Class Name: ${widget.className}");

                        final formData = {
                          // Use widget properties directly
                          'SchoolId': widget.schoolId,
                          'TeamId': widget.doctorId,
                          'DoctorName': widget.doctorName,
                          'SchoolName': widget.schoolName,
                          'ClassName': widget.className,

                          // Class flags
                          'anganwadi': false,
                          'MiniAnganwadi': false,
                          'firstclass': widget.className.toLowerCase().contains(
                            '1st',
                          ),
                          'SecondClass': widget.className
                              .toLowerCase()
                              .contains('2nd'),
                          'ThirdClass': widget.className.toLowerCase().contains(
                            '3rd',
                          ),
                          'FourthClass': widget.className
                              .toLowerCase()
                              .contains('4th'),
                          'FifthClass': widget.className.toLowerCase().contains(
                            '5th',
                          ),
                          'SixthClass': widget.className.toLowerCase().contains(
                            '6th',
                          ),
                          'SeventhClass': widget.className
                              .toLowerCase()
                              .contains('7th'),
                          'EighthClass': widget.className
                              .toLowerCase()
                              .contains('8th'),
                          'NinthClass': widget.className.toLowerCase().contains(
                            '9th',
                          ),
                          'TenthClass': widget.className.toLowerCase().contains(
                            '10th',
                          ),
                          'EleventhClass': widget.className
                              .toLowerCase()
                              .contains('11th'),
                          'TwelthClass': widget.className
                              .toLowerCase()
                              .contains('12th'),

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

                          // Weight/Height status
                          'WeightHeightNormal': bmi >= 18.5 && bmi < 25,
                          'WeightHeightSAM': bmi < 16,
                          'WeightHeightMAM': bmi >= 16 && bmi < 18.5,
                          'WeightHeightSUW': bmi < 16,
                          'WeightHeightMUW': bmi >= 16 && bmi < 18.5,
                          'WeightHeightStunted': bmi < 18.5,

                          // Blood Pressure
                          'BloodPressure': true,
                          'BPNormal': bloodPressureSelections[0],
                          'BPPrehypertension': bloodPressureSelections[1],
                          'BPStage1HTN': bloodPressureSelections[2],
                          'BPStage2HTN': bloodPressureSelections[3],

                          // Vision
                          'AcuityOfVision': (leftEye + rightEye) / 2,
                          'AcuityOfLeftEye': leftEye,
                          'AcuityOfRightEye': rightEye,
                        };

                        _logger.i("Form Data: $formData");

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScreeningFormScreenTwo(
                              previousFormData: formData,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please complete all required fields!',
                            ),
                            backgroundColor: Colors.red,
                          ),
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
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? Function(String?)? validator,
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
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator:
            validator ??
            (isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }
                : null),
      ),
    );
  }
}
