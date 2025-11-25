import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:school_test/config/api_config.dart';
import 'package:school_test/config/endpoints.dart';
import 'package:school_test/models/api_response.dart';
import 'package:school_test/models/district_model.dart';
import 'package:school_test/models/grampanchayat_model.dart';
import 'package:school_test/models/school_model.dart';
import 'package:http/http.dart' as http;
import 'package:school_test/models/taluka_model.dart';
import 'package:school_test/utils/error_popup.dart';

class AddSchoolScreen extends StatefulWidget {
  final int? DoctorId;
  final String doctorName;
  const AddSchoolScreen({super.key, this.DoctorId, required this.doctorName});

  @override
  State<AddSchoolScreen> createState() => _AddSchoolScreenState();
}

class _AddSchoolScreenState extends State<AddSchoolScreen> {
  // Image
  File? selectedImage;
  String? base64Image;

  //  Date of Visit
  DateTime? dateOfBirth;

  final _formKey = GlobalKey<FormState>();
  final _schoolNameController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _principalNameController = TextEditingController();
  final _contactNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // final _visitDateController = TextEditingController();
  // final _latitudeController = TextEditingController();
  // final _longitudeController = TextEditingController();

  bool _isLoadingLocation = false;
  bool _locationFetched = false;
  bool isLoadingDistricts = false;
  bool isLoadingTalukas = false;
  bool isLoadingVillages = false;
  bool? isPrivateSchool;
  List<District> districts = [];
  List<Taluka> talukas = [];
  List<Grampanchayat> villages = [];

  String baseUrl = ApiConfig.baseUrl;
  String? _latitude;
  String? _longitude;
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

  // current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationFetched = false; // ✅ Reset on new fetch
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enable location services'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Location permissions are denied'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permissions are permanently denied'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Settings',
                textColor: Colors.white,
                onPressed: () => Geolocator.openLocationSettings(),
              ),
            ),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude.toStringAsFixed(6);
        _longitude = position.longitude.toStringAsFixed(6);
      });

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address = '';

          if (place.street != null && place.street!.isNotEmpty) {
            address += '${place.street}, ';
          }
          if (place.subLocality != null && place.subLocality!.isNotEmpty) {
            address += '${place.subLocality}, ';
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            address += '${place.locality}, ';
          }
          if (place.subAdministrativeArea != null &&
              place.subAdministrativeArea!.isNotEmpty) {
            address += '${place.subAdministrativeArea}, ';
          }
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty) {
            address += '${place.administrativeArea} ';
          }
          if (place.postalCode != null && place.postalCode!.isNotEmpty) {
            address += '- ${place.postalCode}';
          }

          setState(() {
            _addressController.text = address.trim().replaceAll(
              RegExp(r',\s*$'),
              '',
            );
            _locationFetched = true; // ✅ Mark as successfully fetched
          });
        }
      } catch (e) {
        print('Error getting address: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not fetch address, but coordinates are saved',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() {
          _locationFetched =
              true; // ✅ Still mark as fetched (we have coordinates)
        });
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // radio button
  Widget _buildServiceRadioBool(
    String label,
    bool? selectedValue,
    ValueChanged<bool?> onChanged,
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
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(width: 8),
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
              Text('Yes'),
              SizedBox(width: 4),
              Radio<bool>(
                value: false,
                groupValue: selectedValue,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Text('No'),
            ],
          ),
        ],
      ),
    );
  }

  //fetch Disctrict, Taluka , Village from api and populate in dropdowns

  // 🔹 Get Districts
  Future<List<District>> fetchDistricts() async {
    setState(() {
      isLoadingDistricts = true;
    });

    try {
      final url = Uri.parse("$baseUrl${Endpoints.getDistrict}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Debug: Print the API response to see the structure
        print('Districts API Response: $decoded');

        // Handle if API returns { "data": [...] } or just [...]
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
      print('Error fetching districts: $e');
      return []; // return empty list instead of null
    }
  }

  // 🔹 Get Talukas by DistrictId
  Future<List<Taluka>> fetchTalukas(int districtId) async {
    if (districtId == 0) return []; // return empty list instead of null

    setState(() {
      isLoadingTalukas = true;
      talukas = []; // Clear previous talukas
      selectedTaluka = null;
      villages = []; // Clear villages when district changes
      selectedVillage = null;
    });

    try {
      final url = Uri.parse(
        "$baseUrl${Endpoints.getTaluka}?districtId=$districtId",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('Talukas API Response: $decoded');

        // Handle API returning { "data": [...] } or just [...]
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
      print('Error fetching talukas: $e');
      return []; // return empty list on error
    }
  }

  // 🔹 Get Grampanchayats by TalukaId
  Future<List<Grampanchayat>> fetchGrampanchayats(int talukaId) async {
    if (talukaId == 0) return []; // return empty list instead of null

    setState(() {
      isLoadingVillages = true;
      villages = []; // Clear previous villages
      selectedVillage = null;
    });

    try {
      final url = Uri.parse(
        "$baseUrl${Endpoints.getGrampanchayat}?talukaId=$talukaId",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        print('Villages API Response: $decoded');

        // Handle API returning { "data": [...] } or just [...]
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
      print('Error fetching villages: $e');
      return []; // return empty list on error
    }
  }

  @override
  void initState() {
    super.initState();
    _boysController.addListener(_updateTotal);
    _girlsController.addListener(_updateTotal);

    // Calling district api to populate dropdown
    fetchDistricts();

    // ✅ Auto-fetch location when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  District? selectedDistrict;
  Taluka? selectedTaluka;
  Grampanchayat? selectedVillage;

  //  int? selectedTalukaId
  List<bool> classSelections = List.filled(12, false);
  final _boysController = TextEditingController();
  final _girlsController = TextEditingController();

  bool? nationalDeworming = false; // default NO
  bool? anemiaMukt = true; // default YES
  bool? vitASupplement = false; // default NO

  int? _total;
  void _updateTotal() {
    final int boys = int.tryParse(_boysController.text) ?? 0;
    final int girls = int.tryParse(_girlsController.text) ?? 0;

    setState(() {
      _total = boys + girls; // assuming _total is a state variable
    });
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
    _addressController.dispose(); // ✅ Add this line
    super.dispose();
  }

  /*
    Add School Form Fields
  1. School Name (TextField) 
  2. School ID / DISE code (TextField)
  3. School Principal Name (TextField)  
  4. School Contact No (TextField)
  5. District/Block (Dropdown)
  6. Taluka (Dropdown)
  7. Village (Dropdown)
  8. Classes 1 to 12 (Checkboxes)
  9. Total No.of Students (TextFields)
  10. Services (Radio Buttons)
      - National Deworming Program (Yes/No)
      - Anemia Mukt Bharat (Yes/No)
      - VIT A Supplementation Program (Yes/No)
  11. School Photo (Image Upload)
  12. Submit Button   
  */
  Future<ApiResponse<dynamic>> addSchool(SchoolDetails school) async {
    final url = Uri.parse("$baseUrl${Endpoints.addSchool}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(school.toJson()),
    );

    // Decode the JSON response
    final data = jsonDecode(response.body);

    print("📡 addSchool API raw response: $data");

    // Check both HTTP status and API-level 'success'
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data['success'] == true) {
      return ApiResponse<dynamic>.fromJson(data, null);
    } else {
      // Throw an error with the backend's message (but don’t expose it directly in UI)
      final message = data['responseMessage'] ?? "Failed to add school";
      throw Exception(message);
    }
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
                  maxLength: 10,
                ),

                SizedBox(height: 20),
                _buildRequiredLabel('Location'),
                SizedBox(height: 8),

                // Location Container with dynamic border color
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _locationFetched
                          ? Colors
                                .green // ✅ Green border when successfully fetched
                          : (_isLoadingLocation
                                ? Colors.blue[300]!
                                : Colors.grey[300]!),
                      width: _locationFetched
                          ? 2
                          : 1, // ✅ Thicker border when fetched
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Loading indicator or success message
                      if (_isLoadingLocation)
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Fetching your location...',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      else if (_locationFetched)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 22,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Location fetched successfully',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            // Retry button
                            IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.blue[700],
                                size: 22,
                              ),
                              onPressed: _getCurrentLocation,
                              tooltip: 'Refresh location',
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(
                              Icons.location_off,
                              color: Colors.orange,
                              size: 22,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Unable to fetch location',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Retry button
                            TextButton.icon(
                              onPressed: _getCurrentLocation,
                              icon: Icon(Icons.refresh, size: 18),
                              label: Text('Retry'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue[700],
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),

                      // Show coordinates if available
                      if (_latitude != null && _longitude != null) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _locationFetched
                                ? Colors.green[50]
                                : Colors.blue[50],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _locationFetched
                                  ? Colors.green[200]!
                                  : Colors.blue[200]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: _locationFetched
                                    ? Colors.green[700]
                                    : Colors.blue[700],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Coordinates',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _locationFetched
                                            ? Colors.green[700]
                                            : Colors.blue[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Lat: $_latitude, Long: $_longitude',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Address TextField (editable)
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _addressController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Address will appear here (editable)',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please get location or enter address manually';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildRequiredLabel('Visit Date'),
                SizedBox(height: 8),
                // Date of Birth
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        SizedBox(width: 12),
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
                SizedBox(height: 20),
                _buildRequiredLabel('District/Block'),
                SizedBox(height: 8),

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

                    // Fetch talukas for the selected district
                    final fetchedTalukas = await fetchTalukas(
                      newValue.districtId,
                    );
                    setState(() {
                      talukas = fetchedTalukas;
                    });
                  },
                  hint: 'Select District',
                ),

                SizedBox(height: 20),
                _buildRequiredLabel('Taluka'),
                SizedBox(height: 8),

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

                    // Fetch villages for the selected taluka
                    final fetchedVillages = await fetchGrampanchayats(
                      newValue.talukaId,
                    );
                    setState(() {
                      villages = fetchedVillages;
                    });
                  },
                  hint: 'Select Taluka',
                ),

                SizedBox(height: 20),
                _buildRequiredLabel('Village'),
                SizedBox(height: 8),

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

                SizedBox(height: 20),

                _buildRequiredLabel('School Type'),
                SizedBox(height: 8),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      // Private School Checkbox
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPrivateSchool = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isPrivateSchool == true
                                  ? Colors.blue[50]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isPrivateSchool == true
                                    ? Colors.blue
                                    : Colors.grey[300]!,
                                width: isPrivateSchool == true ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isPrivateSchool == true
                                        ? Colors.blue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isPrivateSchool == true
                                          ? Colors.blue
                                          : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: isPrivateSchool == true
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Private',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isPrivateSchool == true
                                          ? Colors.blue
                                          : Colors.black87,
                                      fontWeight: isPrivateSchool == true
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // Government School Checkbox
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPrivateSchool = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isPrivateSchool == false
                                  ? Colors.blue[50]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isPrivateSchool == false
                                    ? Colors.blue
                                    : Colors.grey[300]!,
                                width: isPrivateSchool == false ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isPrivateSchool == false
                                        ? Colors.blue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isPrivateSchool == false
                                          ? Colors.blue
                                          : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: isPrivateSchool == false
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Government',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isPrivateSchool == false
                                          ? Colors.blue
                                          : Colors.black87,
                                      fontWeight: isPrivateSchool == false
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    childAspectRatio: 2.5, // Adjust height ratio
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    String suffix = _getOrdinalSuffix(index + 1);
                    return _buildClassCheckbox(
                      index,
                      '${index + 1}$suffix Class',
                    );
                  },
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
                                '${_total ?? 0}',
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

                _buildServiceRadioBool(
                  'National Deworming Program',
                  nationalDeworming,
                  (value) => setState(() => nationalDeworming = value),
                ),
                SizedBox(height: 16),

                _buildServiceRadioBool(
                  'Anemia Mukt Bharat',
                  anemiaMukt,
                  (value) => setState(() => anemiaMukt = value),
                ),
                SizedBox(height: 16),

                _buildServiceRadioBool(
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
                    _buildPhotoUpload(context); // opens camera/gallery chooser
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
                    child: selectedImage == null
                        ? Column(
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
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                selectedImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // 1️⃣ Validate the form
                      if (!_formKey.currentState!.validate()) return;

                      // 2️⃣ Ensure district, taluka, village are selected
                      if (selectedDistrict == null ||
                          selectedTaluka == null ||
                          selectedVillage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please select district, taluka, and village',
                            ),
                          ),
                        );
                        return;
                      }

                      // 3️⃣ Create School object
                      final school = SchoolDetails(
                        // SchoolId:
                        schoolName: _schoolNameController.text,
                        schoolCode: _schoolIdController.text,
                        schoolPrincipalName: _principalNameController.text,
                        schoolContactNumber: _contactNoController.text,
                        VisitDate: dateOfBirth,
                        districtId: selectedDistrict?.districtId,
                        districtName: selectedDistrict?.districtName,
                        talukaId: selectedTaluka?.talukaId,
                        talukaName: selectedTaluka?.talukaName,
                        grampanchayatId: selectedVillage?.grampanchayatId,
                        grampanchayatName: selectedVillage?.grampanchayatName,

                        latitude: _latitude ?? '',
                        longitude: _longitude ?? '',
                        SchoolAddress: _addressController.text,
                        // Classes
                        firstClass: classSelections[0],
                        secondClass: classSelections[1],
                        thirdClass: classSelections[2],
                        fourthClass: classSelections[3],
                        fifthClass: classSelections[4],
                        sixthClass: classSelections[5],
                        seventhClass: classSelections[6],
                        eighthClass: classSelections[7],
                        ninethClass: classSelections[8],
                        tenthClass: classSelections[9],
                        eleventhClass: classSelections[10],
                        twelthClass: classSelections[11],
                        // School Type
                        schoolType: isPrivateSchool == true
                            ? 'Private'
                            : 'Government',
                        // Students
                        totalNoOFBoys: int.tryParse(_boysController.text),
                        totalNoOfGirls: int.tryParse(_girlsController.text),
                        total:
                            (int.tryParse(_boysController.text) ?? 0) +
                            (int.tryParse(_girlsController.text) ?? 0),

                        // Programs
                        nationalDeworingProgram: nationalDeworming,
                        anemiaMuktaBharat: anemiaMukt,
                        vitASupplementationProgram: vitASupplement,

                        // Anganwadi flags
                        anganwadi: false,
                        miniAnganwadi: false,

                        // Media & User
                        SchoolPhoto:
                            base64Image, // converted uploaded image to Base64

                        TeamId: widget.DoctorId!,
                        // logged-in user ID
                      );

                      try {
                        final response = await addSchool(school);
                        print("add scholl response: ${response.data}");

                        // 5️⃣ Show success message
                        showErrorPopup(
                          context,
                          message: "School added Successfully",
                          isSuccess: true,
                        );

                        // 6️⃣ Optional: Reset form
                        _formKey.currentState!.reset();
                        setState(() {
                          selectedDistrict = null;
                          selectedTaluka = null;
                          selectedVillage = null;
                          isPrivateSchool = null; // ✅ Add this
                          classSelections = List.filled(12, false);
                          _boysController.clear();
                          _girlsController.clear();
                          _addressController.clear();
                          _latitude = null;
                          _longitude = null;
                          nationalDeworming = false;
                          anemiaMukt = false;
                          vitASupplement = false;
                          selectedImage = null;
                          base64Image = null;
                        });

                        Navigator.pop(context);
                      } catch (e) {
                        // 7️⃣ Handle errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add school: $e')),
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
    int? maxLength, // 👈 new optional parameter
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
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          if (keyboardType == TextInputType.phone)
            FilteringTextInputFormatter.digitsOnly, // 👈 only digits for phone
        ],
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
                  padding: EdgeInsets.only(left: 16),
                  child: Text(hint, style: TextStyle(color: Colors.grey[500])),
                )
              : null,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(getLabel(item)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildClassCheckbox(int index, String className) {
    final isSelected = classSelections[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          classSelections[index] = !classSelections[index];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // Center content
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 10)
                  : null,
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                className,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.blue : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //image pick
  // Pick image from gallery/camera
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

  /// Custom Aspect Ratio (2x3)

  // //image build
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

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
