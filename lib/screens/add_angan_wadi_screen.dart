import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:school_test/config/api_config.dart';
import 'package:school_test/config/endpoints.dart';
import 'package:school_test/models/district_model.dart';
import 'package:school_test/models/taluka_model.dart';
import 'package:school_test/models/grampanchayat_model.dart';
import 'package:school_test/models/school_model.dart';
import 'package:http/http.dart' as http;
import 'package:school_test/screens/add_school_screen.dart';
import 'package:school_test/utils/error_popup.dart';

class AddAnganWadiScreen extends StatefulWidget {
  final int? DoctorId;
  final String doctorName;
  const AddAnganWadiScreen({
    super.key,
    this.DoctorId,
    required this.doctorName,
  });

  @override
  State<AddAnganWadiScreen> createState() => _AddAnganWadiScreenState();
}

class _AddAnganWadiScreenState extends State<AddAnganWadiScreen> {
  //logger initializtion
  final _logger = Logger();
  // Form Key
  final _formKey = GlobalKey<FormState>();

  //DateTime
  DateTime? dateOfBirth;
  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _workerNameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _boysController = TextEditingController();
  final TextEditingController _girlsController = TextEditingController();

  // Location variables
  double? _currentLatitude;
  double? _currentLongitude;

  // Loading states
  bool isLoadingDistricts = false;
  bool isLoadingTalukas = false;
  bool isLoadingVillages = false;

  // API Data Lists
  List<District> districts = [];
  List<Taluka> talukas = [];
  List<Grampanchayat> villages = [];

  // Dropdown selections
  District? selectedDistrict;
  Taluka? selectedTaluka;
  Grampanchayat? selectedVillage;

  // Radio button selections
  String? selectedAnganWadiType; // ← Make it String, not bool
  bool? nationalDewormingProgram = false; // Changed to bool with default NO
  bool? anemiaMuktBharat = true; // Changed to bool with default Yes
  bool? vitASupplementation = false; // Changed to bool with default NO

  // Image
  File? selectedImage;
  String? base64Image;

  String baseUrl = ApiConfig.baseUrl;

  @override
  void initState() {
    super.initState();
    // Initialize listeners and API calls
    _boysController.addListener(_updateTotal);
    _girlsController.addListener(_updateTotal);

    fetchDistricts();
  }

  @override
  void dispose() {
    _boysController.removeListener(_updateTotal);
    _girlsController.removeListener(_updateTotal);
    _nameController.dispose();
    _idController.dispose();
    _workerNameController.dispose();
    _contactController.dispose();
    _boysController.dispose();
    _girlsController.dispose();
    super.dispose();
  }

  //Date Selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[800]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.blue[800]!,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != dateOfBirth) {
      setState(() {
        dateOfBirth = picked;
      });
    }
  }

  // Fetch Districts
  Future<List<District>> fetchDistricts() async {
    setState(() {
      isLoadingDistricts = true;
    });

    try {
      final url = Uri.parse("$baseUrl${Endpoints.getDistrict}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        _logger.i('Districts API Response: $decoded');

        final List<dynamic> data = decoded is Map<String, dynamic>
            ? decoded['data'] ?? []
            : decoded;

        final fetchedDistricts = data.map((e) => District.fromJson(e)).toList();

        setState(() {
          districts = fetchedDistricts;
          isLoadingDistricts = false;
        });

        return fetchedDistricts;
      } else {
        setState(() {
          isLoadingDistricts = false;
        });
        throw Exception("Failed to fetch districts: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoadingDistricts = false;
      });
      _logger.e('Error fetching districts: $e');
      return [];
    }
  }

  // Fetch Talukas by DistrictId
  Future<List<Taluka>> fetchTalukas(int districtId) async {
    if (districtId == 0) return [];

    setState(() {
      isLoadingTalukas = true;
      talukas = [];
      selectedTaluka = null;
      villages = [];
      selectedVillage = null;
    });

    try {
      final url = Uri.parse(
        "$baseUrl${Endpoints.getTaluka}?districtId=$districtId",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        _logger.t('Talukas API Response: $decoded');

        final List<dynamic> data = decoded is Map<String, dynamic>
            ? decoded['data'] ?? []
            : decoded;

        final fetchedTalukas = data.map((e) => Taluka.fromJson(e)).toList();

        setState(() {
          talukas = fetchedTalukas;
          isLoadingTalukas = false;
        });

        return fetchedTalukas;
      } else {
        setState(() {
          isLoadingTalukas = false;
        });
        throw Exception("Failed to fetch talukas: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoadingTalukas = false;
      });
      _logger.e('Error fetching talukas: $e');
      return [];
    }
  }

  // Fetch Grampanchayats by TalukaId
  Future<List<Grampanchayat>> fetchGrampanchayats(int talukaId) async {
    if (talukaId == 0) return [];

    setState(() {
      isLoadingVillages = true;
      villages = [];
      selectedVillage = null;
    });

    try {
      final url = Uri.parse(
        "$baseUrl${Endpoints.getGrampanchayat}?talukaId=$talukaId",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        _logger.i('Villages API Response: $decoded');

        final List<dynamic> data = decoded is Map<String, dynamic>
            ? decoded['data'] ?? []
            : decoded;

        final fetchedVillages = data
            .map((e) => Grampanchayat.fromJson(e))
            .toList();

        setState(() {
          villages = fetchedVillages;
          isLoadingVillages = false;
        });

        return fetchedVillages;
      } else {
        setState(() {
          isLoadingVillages = false;
        });
        throw Exception("Failed to fetch villages: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoadingVillages = false;
      });
      _logger.e('Error fetching villages: $e');
      return [];
    }
  }

  // Image Picker with Cropper - Updated to match AddSchoolScreen
  Future<void> _pickAndCropImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920, // Optimize image size
        maxHeight: 1920,
        imageQuality: 85, // Balance quality and file size
      );

      if (image == null) return;

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.black,
            activeControlsWidgetColor: Colors.blue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPresetCustom(),
            ],
          ),
        ],
      );

      if (croppedFile == null) return;

      // Convert to base64
      final file = File(croppedFile.path);
      final bytes = await file.readAsBytes();
      final base64 = base64Encode(bytes);

      // Check file size (optional: warn if > 2MB)
      final fileSizeInBytes = bytes.length;
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB > 5) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Image is large (${fileSizeInMB.toStringAsFixed(1)}MB). Upload may take time.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      setState(() {
        selectedImage = file;
        base64Image = base64;
      });
    } on PlatformException catch (e) {
      print("Platform error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to access ${source == ImageSource.camera ? 'camera' : 'gallery'}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error picking/cropping image: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Photo Upload Bottom Sheet - Updated to match AddSchoolScreen
  void _buildPhotoUpload(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Upload Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Divider(height: 1),

            // Gallery Option
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.photo_library, color: Colors.blue),
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndCropImage(context, ImageSource.gallery);
              },
            ),

            // Camera Option
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.camera_alt, color: Colors.green),
              ),
              title: Text(
                'Take a Photo',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickAndCropImage(context, ImageSource.camera);
              },
            ),

            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Submit Anganwadi Data - Updated to match AddSchoolScreen pattern
  Future<void> submitAnganwadiData() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDistrict == null ||
        selectedTaluka == null ||
        selectedVillage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select district, taluka, and village'),
        ),
      );
      return;
    }

    if (_latitudeController.text.isEmpty || _longitudeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter latitude and longitude')),
      );
      return;
    }

    if (selectedAnganWadiType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Angan Wadi type')),
      );
      return;
    }

    try {
      // --- Create object ---
      final school = SchoolDetails(
        schoolName: _nameController.text.trim(),
        schoolCode: _idController.text.trim(),
        schoolPrincipalName: _workerNameController.text.trim(),
        schoolContactNumber: _contactController.text.trim(),

        districtId: selectedDistrict?.districtId,
        districtName: selectedDistrict?.districtName,
        talukaId: selectedTaluka?.talukaId,
        talukaName: selectedTaluka?.talukaName,
        grampanchayatId: selectedVillage?.grampanchayatId,
        grampanchayatName: selectedVillage?.grampanchayatName,

        latitude: _latitudeController.text.trim(),
        longitude: _longitudeController.text.trim(),

        VisitDate: dateOfBirth, // Add this line

        anganwadi: selectedAnganWadiType == 'AnganWadi',
        miniAnganwadi: selectedAnganWadiType == 'Mini AnganWadi',

        firstClass: false,
        secondClass: false,
        thirdClass: false,
        fourthClass: false,
        fifthClass: false,
        sixthClass: false,
        seventhClass: false,
        eighthClass: false,
        ninethClass: false,
        tenthClass: false,
        eleventhClass: false,
        twelthClass: false,

        totalNoOFBoys: int.tryParse(_boysController.text),
        totalNoOfGirls: int.tryParse(_girlsController.text),
        total: totalStudents,

        nationalDeworingProgram: nationalDewormingProgram,
        anemiaMuktaBharat: anemiaMuktBharat,
        vitASupplementationProgram: vitASupplementation,

        SchoolPhoto: base64Image,
        TeamId: widget.DoctorId ?? 1,
      );

      final url = Uri.parse("$baseUrl${Endpoints.addSchool}");
      final payload = jsonEncode(school.toJson());

      // 🔍 Log what we’re sending
      _logger.i("=== SUBMITTING ANGANWADI DATA ===");
      _logger.i("URL: $url");
      _logger.i("HEADERS: {Content-Type: application/json}");
      _logger.i("PAYLOAD: $payload");

      // --- API Call ---
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      _logger.i("Response Status: ${response.statusCode}");
      _logger.i("Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          _logger.i("Angan Wadi data submitted successfully.");

          /// showing a success popup
          await showErrorPopup(
            context,
            isSuccess: true,
            message: 'Angan Wadi data submitted successfully!',
          );

          /// Form reset
          _formKey.currentState!.reset();
          setState(() {
            selectedDistrict = null;
            selectedTaluka = null;
            selectedVillage = null;
            selectedAnganWadiType = null;
            _workerNameController.clear();
            _contactController.clear();
            _idController.clear();
            _nameController.clear();
            _boysController.clear();
            _girlsController.clear();
            nationalDewormingProgram = false;
            anemiaMuktBharat = true;
            vitASupplementation = false;
            _currentLatitude = null;
            _currentLongitude = null;
            selectedImage = null;
            base64Image = null;
          });

          /// checking the context is still mounted before navigating back././//
          if (context.mounted) {
            Navigator.pop(context, true);
          }
        } else {
          // Backend sent success=false (like your case)
          final message = data['responseMessage'] ?? 'Failed to submit data.';
          _logger.w("Server responded with success=false: $message");
          showErrorPopup(context, isSuccess: false, message: message);
        }
      } else {
        final message = data['responseMessage'] ?? 'Server error occurred.';
        _logger.e("Submission failed: $message");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e, stack) {
      _logger.e("Error submitting Angan Wadi data: $e\n$stack");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Calculate total students
  int get totalStudents {
    final boys = int.tryParse(_boysController.text) ?? 0;
    final girls = int.tryParse(_girlsController.text) ?? 0;
    return boys + girls;
  }

  void _updateTotal() {
    setState(() {});
  }

  // Service Radio Widget - Updated to match AddSchoolScreen pattern
  Widget _buildServiceRadioBool(
    String label,
    bool? selectedValue,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<bool>(
                value: true,
                groupValue: selectedValue,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const Text('Yes'),
              const SizedBox(width: 4),
              Radio<bool>(
                value: false,
                groupValue: selectedValue,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const Text('No'),
            ],
          ),
        ],
      ),
    );
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Angan Wadi Name
                      _buildRequiredLabel('Angan Wadi Name'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nameController,
                        hintText: 'Enter Name',
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),

                      // Angan Wadi ID / DISE code
                      _buildRequiredLabel('Angan Wadi ID / DISE code'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _idController,
                        hintText: 'Enter ID/DISE code',
                        isRequired: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Angan Wadi Worker Name
                      _buildRequiredLabel('Angan Wadi Worker Name'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _workerNameController,
                        hintText: 'Enter Name',
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),

                      // Angan Wadi Contact No
                      _buildRequiredLabel('Angan Wadi Contact No'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _contactController,
                        hintText: 'Enter Contact No',
                        isRequired: true,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          if (value.length != 10) {
                            return 'Contact number must be 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // District/Block with API data
                      _buildRequiredLabel('District/Block'),
                      const SizedBox(height: 8),
                      _buildDropdown<District>(
                        value: selectedDistrict,
                        items: districts,
                        getLabel: (district) => district.districtName,
                        onChanged: (District? newValue) async {
                          if (newValue == null) return;

                          setState(() {
                            selectedDistrict = newValue;
                            selectedTaluka = null;
                            selectedVillage = null;
                            talukas = [];
                            villages = [];
                          });

                          await fetchTalukas(newValue.districtId);
                        },
                        hint: 'Select District',
                      ),
                      const SizedBox(height: 20),

                      // Taluka with API data
                      _buildRequiredLabel('Taluka'),
                      const SizedBox(height: 8),
                      _buildDropdown<Taluka>(
                        value: selectedTaluka,
                        items: talukas,
                        getLabel: (taluka) => taluka.talukaName,
                        onChanged: (Taluka? newValue) async {
                          if (newValue == null) return;

                          setState(() {
                            selectedTaluka = newValue;
                            selectedVillage = null;
                            villages = [];
                          });

                          await fetchGrampanchayats(newValue.talukaId);
                        },
                        hint: 'Select Taluka',
                      ),
                      const SizedBox(height: 20),

                      // Village with API data
                      _buildRequiredLabel('Village'),
                      const SizedBox(height: 8),
                      _buildDropdown<Grampanchayat>(
                        value: selectedVillage,
                        items: villages,
                        getLabel: (village) => village.grampanchayatName,
                        onChanged: (Grampanchayat? newValue) {
                          setState(() {
                            selectedVillage = newValue;
                          });
                        },
                        hint: 'Select Village',
                      ),

                      const SizedBox(height: 20),

                      // Visit Date Section
                      _buildRequiredLabel('Visit Date'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  dateOfBirth == null
                                      ? 'Select Visit Date'
                                      : DateFormat(
                                          'dd MMM yyyy',
                                        ).format(dateOfBirth!),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: dateOfBirth == null
                                        ? Colors.grey[500]
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRequiredLabel('Latitude'),
                                SizedBox(height: 8),
                                _buildTextField(
                                  controller: _latitudeController,
                                  hintText: 'Enter Latitude',
                                  isRequired: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRequiredLabel('Longitude'),
                                SizedBox(height: 8),
                                _buildTextField(
                                  controller: _longitudeController,
                                  hintText: 'Enter Longitude',
                                  isRequired: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Angan Wadi Type Selection
                      const Text(
                        'Angan Wadi Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAnganWadiOption('Mini AnganWadi'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: _buildAnganWadiOption('AnganWadi')),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Total Students Section
                      const Text(
                        'Total No.of Students',
                        style: TextStyle(
                          fontSize: 18,
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
                                  hintText: 'No.of Boys',
                                  keyboardType: TextInputType.number,
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
                                _buildRequiredLabel('Girls'),
                                const SizedBox(height: 8),
                                _buildTextField(
                                  controller: _girlsController,
                                  hintText: 'No.of Girls',
                                  keyboardType: TextInputType.number,
                                  isRequired: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$totalStudents',
                                      style: const TextStyle(
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
                      const SizedBox(height: 30),

                      // Services Section
                      const Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildServiceRadioBool(
                        'National Deworming Program',
                        nationalDewormingProgram,
                        (value) =>
                            setState(() => nationalDewormingProgram = value),
                      ),
                      const SizedBox(height: 16),
                      _buildServiceRadioBool(
                        'Anemia Mukt Bharat',
                        anemiaMuktBharat,
                        (value) => setState(() => anemiaMuktBharat = value),
                      ),
                      const SizedBox(height: 16),
                      _buildServiceRadioBool(
                        'VIT A Supplementation Program',
                        vitASupplementation,
                        (value) => setState(() => vitASupplementation = value),
                      ),
                      const SizedBox(height: 30),

                      // Photo Upload Section
                      const Text(
                        'Angan Wadi Photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _buildPhotoUpload(context),
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
                          child: selectedImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Click to Upload\nAngan Wadi Photo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(
                                      selectedImage!,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
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
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
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

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required String Function(T) getLabel,
    required ValueChanged<T?> onChanged,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(hint, style: TextStyle(color: Colors.grey[500])),
                )
              : null,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(getLabel(item)),
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
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
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

  Widget _buildSubmitButton() {
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
        height: 50,
        child: ElevatedButton(
          onPressed: submitAnganwadiData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Aspect Ratio class for image cropping
class _CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
