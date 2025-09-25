import 'package:flutter/material.dart';

class AddSchoolScreen extends StatefulWidget {
  const AddSchoolScreen({super.key});

  @override
  State<AddSchoolScreen> createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _principalNameController = TextEditingController();
  final _contactNoController = TextEditingController();


  
  String? selectedDistrict = 'नागपुर';
  String? selectedTaluka = 'हिंगणा';
  String? selectedVillage;

  List<bool> classSelections = List.filled(12, false);
  final _boysController = TextEditingController();
  final _girlsController = TextEditingController();

  String? nationalDeworming = 'NO';
  String? anemiaMukt = 'Yes';
  String? vitASupplement = 'NO';
  void initState() {
    super.initState();
    _boysController.addListener(_updateTotal);
    _girlsController.addListener(_updateTotal);
  }

  void _updateTotal() {
    setState(() {});
  }

  @override
  void dispose() {
    _boysController.removeListener(_updateTotal);
    _girlsController.removeListener(_updateTotal);
    _boysController.dispose();
    _girlsController.dispose();
    _schoolNameController.dispose();
    _schoolIdController.dispose();
    _principalNameController.dispose();
    _contactNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Add School'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequiredLabel('School Name'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _schoolNameController,
                  hintText: 'Enter Name',
                  isRequired: true,
                ),
                SizedBox(height: 20),

                _buildRequiredLabel('School ID / DISE code'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _schoolIdController,
                  hintText: 'Enter ID/DISE code',
                  isRequired: true,
                ),
                SizedBox(height: 20),

                _buildRequiredLabel('School Principal Name'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _principalNameController,
                  hintText: 'Enter Name',
                  isRequired: true,
                ),
                SizedBox(height: 20),

                _buildRequiredLabel('School Contact No'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _contactNoController,
                  hintText: 'Enter Contact No',
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),

                _buildRequiredLabel('District/Block'),
                SizedBox(height: 8),
                _buildDropdown(
                  value: selectedDistrict,
                  items: ['नागपुर', 'मुंबई', 'पुणे'],
                  onChanged: (value) =>
                      setState(() => selectedDistrict = value),
                ),
                SizedBox(height: 20),

                _buildRequiredLabel('Taluka'),
                SizedBox(height: 8),
                _buildDropdown(
                  value: selectedTaluka,
                  items: ['हिंगणा', 'कामठी', 'रामटेक'],
                  onChanged: (value) => setState(() => selectedTaluka = value),
                ),
                SizedBox(height: 20),

                _buildRequiredLabel('Village'),
                SizedBox(height: 8),
                _buildDropdown(
                  value: selectedVillage,
                  hint: 'Select Village',
                  items: ['Village 1', 'Village 2', 'Village 3'],
                  onChanged: (value) => setState(() => selectedVillage = value),
                ),
                SizedBox(height: 30),

                Text(
                  'Classes 1 to 12',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: List.generate(12, (index) {
                    String suffix = _getOrdinalSuffix(index + 1);
                    return _buildClassCheckbox(
                      index,
                      '${index + 1}$suffix Class',
                    );
                  }),
                ),
                SizedBox(height: 30),

                Text(
                  'Total No.of Students',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRequiredLabel('Boys'),
                          SizedBox(height: 8),
                          _buildTextField(
                            controller: _boysController,
                            hintText: 'No.of Boys',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRequiredLabel('Girls'),
                          SizedBox(height: 8),
                          _buildTextField(
                            controller: _girlsController,
                            hintText: 'No.of Girls',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 56, // Match the height of text fields
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                '${(int.tryParse(_boysController.text) ?? 0) + (int.tryParse(_girlsController.text) ?? 0)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(height: 30),

                Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

                _buildServiceRadio(
                  'National Deworming Program',
                  nationalDeworming,
                  (value) => setState(() => nationalDeworming = value),
                ),
                SizedBox(height: 16),

                _buildServiceRadio(
                  'Anemia Mukt Bharat',
                  anemiaMukt,
                  (value) => setState(() => anemiaMukt = value),
                ),
                SizedBox(height: 16),

                _buildServiceRadio(
                  'VIT A Supplementation Program',
                  vitASupplement,
                  (value) => setState(() => vitASupplement = value),
                ),
                SizedBox(height: 30),

                Text(
                  'School Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    // Handle photo upload
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Click to Upload\nSchool Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('School added successfully!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(height: 40),
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
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: [
          TextSpan(text: text),
          TextSpan(
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
    String? hint,
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
          hint: hint != null
              ? Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(hint, style: TextStyle(color: Colors.grey[500])),
                )
              : null,
          isExpanded: true,
          icon: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.blue),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(item),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildClassCheckbox(int index, String className) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: classSelections[index],
            onChanged: (bool? value) {
              setState(() {
                classSelections[index] = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(className, style: TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

Widget _buildServiceRadio(
  String label,
  String? selectedValue,
  ValueChanged<String?> onChanged,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.black87)),
        Row(
          children: [
            Radio<String>(
              value: 'Yes',
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
            Text('Yes'),
            Radio<String>(
              value: 'NO',
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
            Text('NO'),
          ],
        ),
      ],
    ),
  );
}
