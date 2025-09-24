import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddAnganWadiScreen extends StatefulWidget {
  const AddAnganWadiScreen({super.key});

  @override
  State<AddAnganWadiScreen> createState() => _AddAnganWadiScreenState();
}

class _AddAnganWadiScreenState extends State<AddAnganWadiScreen> {
  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _workerNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _boysController = TextEditingController();
  final TextEditingController _girlsController = TextEditingController();

  // Dropdown selections
  String? selectedDistrict;
  String? selectedTaluka;
  String? selectedVillage;

  // Radio button selections
  String? selectedAnganWadiType;
  String? nationalDewormingProgram;
  String? anemiaMuktBharat;
  String? vitASupplementation;

  // Image
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Dropdown data - same as school screen
  final List<String> districts = ['नागपुर', 'मुंबई', 'पुणे'];
  final List<String> talukas = ['हिंगणा', 'कामठी', 'रामटेक'];
  final List<String> villages = ['हिंगणगाव', 'कामठीगाव', 'रामटेकगाव'];

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _workerNameController.dispose();
    _contactController.dispose();
    _boysController.dispose();
    _girlsController.dispose();
    super.dispose();
  }

  // Calculate total students
  int get totalStudents {
    final boys = int.tryParse(_boysController.text) ?? 0;
    final girls = int.tryParse(_girlsController.text) ?? 0;
    return boys + girls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Add Angan Wadi'),
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
                    // Angan Wadi Name
                    _buildRequiredLabel('Angan Wadi Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Enter Name',
                    ),
                    const SizedBox(height: 24),

                    // Angan Wadi ID / DISE code
                    _buildRequiredLabel('Angan Wadi ID / DISE code'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _idController,
                      hint: 'Enter ID/DISE code',
                    ),
                    const SizedBox(height: 24),

                    // Angan Wadi Worker Name
                    _buildRequiredLabel('Angan Wadi Worker Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _workerNameController,
                      hint: 'Enter Name',
                    ),
                    const SizedBox(height: 24),

                    // Angan Wadi Contact No
                    _buildRequiredLabel('Angan Wadi Contact No'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _contactController,
                      hint: 'Enter Contact No',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),

                    // District/Block
                    _buildRequiredLabel('District/Block'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedDistrict,
                      hint: 'Select District',
                      items: districts,
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = value;
                          selectedTaluka = null;
                          selectedVillage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Taluka
                    _buildRequiredLabel('Taluka'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedTaluka,
                      hint: 'Select Taluka',
                      items: talukas,
                      onChanged: (value) {
                        setState(() {
                          selectedTaluka = value;
                          selectedVillage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Village
                    _buildRequiredLabel('Village'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedVillage,
                      hint: 'Select Village',
                      items: villages,
                      onChanged: (value) {
                        setState(() {
                          selectedVillage = value;
                        });
                      },
                    ),
                    const SizedBox(height: 32),

                    // Angan Wadi Type Selection
                    const Text(
                      'Angan Wadi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAnganWadiOption('Mini Angan Wadi'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAnganWadiOption('Angan Wadi'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Total Students Section
                    const Text(
                      'Total No.of Students',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                              _buildRequiredLabel('Boys'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _boysController,
                                hint: 'No.of Boys',
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRequiredLabel('Girls'),
                              const SizedBox(height: 8),
                              _buildTextField(
                                controller: _girlsController,
                                hint: 'No.of Girls',
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            '$totalStudents',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Services Section
                    const Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildServiceOption(
                      'National Deworming Program',
                      nationalDewormingProgram,
                      (value) => setState(() => nationalDewormingProgram = value),
                    ),
                    const SizedBox(height: 16),
                    _buildServiceOption(
                      'Anemia Mukt Bharat',
                      anemiaMuktBharat,
                      (value) => setState(() => anemiaMuktBharat = value),
                    ),
                    const SizedBox(height: 16),
                    _buildServiceOption(
                      'VIT A Supplementation Program',
                      vitASupplementation,
                      (value) => setState(() => vitASupplementation = value),
                    ),
                    const SizedBox(height: 32),

                    // Photo Upload Section
                    const Text(
                      'Angan Wadi Photo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPhotoUpload(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
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
    required String hint,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
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

  Widget _buildAnganWadiOption(String option) {
    final isSelected = selectedAnganWadiType == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnganWadiType = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
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
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.blue : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOption(String title, String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildRadioOption('Yes', value, onChanged),
            const SizedBox(width: 24),
            _buildRadioOption('NO', value, onChanged),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioOption(String option, String? groupValue, ValueChanged<String?> onChanged) {
    final isSelected = groupValue == option;
    return GestureDetector(
      onTap: () => onChanged(option),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.blue : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: isSelected
                ? const Center(
                    child: Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 8,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            option,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.blue : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.blue[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Colors.blue[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click to Upload',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Angan Wadi Photo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile
      ? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSubmitButton() {
    // Check if all required fields are filled
    final isFormValid = _nameController.text.isNotEmpty &&
        _idController.text.isNotEmpty &&
        _workerNameController.text.isNotEmpty &&
        _contactController.text.isNotEmpty &&
        selectedDistrict != null &&
        selectedTaluka != null &&
        selectedVillage != null &&
        selectedAnganWadiType != null &&
        _boysController.text.isNotEmpty &&
        _girlsController.text.isNotEmpty &&
        nationalDewormingProgram != null &&
        anemiaMuktBharat != null &&
        vitASupplementation != null;

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
          onPressed: isFormValid
              ? () {
                  // TODO: Implement form submission and navigation
                  // Collect all form data
                  final formData = {
                    'name': _nameController.text,
                    'id': _idController.text,
                    'workerName': _workerNameController.text,
                    'contact': _contactController.text,
                    'district': selectedDistrict,
                    'taluka': selectedTaluka,
                    'village': selectedVillage,
                    'type': selectedAnganWadiType,
                    'boys': _boysController.text,
                    'girls': _girlsController.text,
                    'totalStudents': totalStudents,
                    'nationalDeworming': nationalDewormingProgram,
                    'anemiaMukt': anemiaMuktBharat,
                    'vitA': vitASupplementation,
                    'image': selectedImage?.path,
                  };
                  
                  // For now, show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Angan Wadi data submitted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  print('Form Data: $formData');
                  Navigator.of(context).pop();
                  // TODO: Navigate to next screen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => NextScreen(data: formData),
                  //   ),
                  // );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFormValid ? Colors.blue[800] : Colors.grey[400],
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
    );
  }
}