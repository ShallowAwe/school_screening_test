import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:school_test/config/api_config.dart';
import 'package:school_test/config/endpoints.dart';
import 'package:school_test/models/ScreenedChild.dart';
import 'package:school_test/models/district_model.dart';
import 'package:school_test/models/grampanchayat_model.dart';
import 'package:school_test/models/school.dart';
import 'package:school_test/models/school_model.dart';
import 'package:school_test/models/taluka_model.dart';
import 'package:school_test/screens/add_student_screen_school.dart';

import 'package:http/http.dart' as http;
import 'package:school_test/screens/student_info_screen.dart';

class ScreenningSchoolScreen extends StatefulWidget {
  final int? doctorId;
  final String doctorName;
  // final String? className;
  // final String? schoolName;
  const ScreenningSchoolScreen({
    super.key,
    this.doctorId,
    required this.doctorName,
  });

  @override
  State<ScreenningSchoolScreen> createState() => _ScreenningSchoolScreenState();
}

class _ScreenningSchoolScreenState extends State<ScreenningSchoolScreen> {
  //intializing the logger
  Logger logger = Logger();
  District? selectedDistrict;
  Taluka? selectedTaluka;
  Grampanchayat? selectedVillage;
  School? selectedSchool;
  String? selectedClass;
  SchoolDetails? schoolDetails;
  String? schoolDetailsError;

  late String className;

  //school data
  Map<String, Map<String, dynamic>> schoolData = {};

  bool isLoadingDistricts = false;
  bool isLoadingTalukas = false;
  bool isLoadingVillages = false;
  bool isLoadingSchools = false;
  bool isFetchingSchools = false;
  bool isLoadingSchoolDetails = false;

  String? schoolFetchError;

  List<District> districts = [];
  List<Taluka> talukas = [];
  List<Grampanchayat> villages = [];
  List<School> schools = [];

  String baseUrl = ApiConfig.baseUrl;

  @override
  void initState() {
    super.initState();
    // logger.i(widget.schoolName);
    fetchDistricts(); // Fetch districts on screen load
  }

  // fetch  district, taluka , village , school id , screended studentrs , from api and populate the dropdowns accordingly
  // fetch school data from api and populate the school information section
  Future<SchoolDetails?> fetchSchoolDetails(int schoolId) async {
    final url = Uri.parse(
      "$baseUrl/api/Rbsk/GetAllSchoolDataWithSchoolId?SchoolId=$schoolId",
    );
    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 180)); // ⏱ Timeout protection

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          if (decoded['success'] == true && decoded['schools'] != null) {
            return SchoolDetails.fromJson(
              decoded['schools'],
            ); // ✅ Direct object, no [0]
          } else {
            logger.e('⚠️ No schools found or success=false:${response.body}');
          }
        } else {
          logger.e('⚠️ Unexpected JSON format');
        }
      } else {
        logger.f('❌ Server error: ${response.statusCode}');
      }
    } on SocketException {
      logger.f('❌ Network error: No Internet connection');
    } on FormatException {
      logger.f('❌ Invalid JSON format');
    } on HttpException {
      logger.f('❌ HTTP error occurred');
    } on TimeoutException {
      logger.f('❌ Request timed out');
    } catch (e, stack) {
      logger.f('❌ Unexpected error: $e');
      logger.i(stack);
    }

    return null;
  }

  // 🔹 Fetch Screened Data by SchoolId and Class
  Future<List<ScreenedChild>> fetchScreenedData({
    required int schoolId,
    required String className,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/Rbsk/GetAllSchoolDataWithSchoolId?SchoolId=$schoolId',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'schoolId': schoolId, 'class': className}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['success'] == true && decoded['data'] != null) {
          final List<dynamic> data = decoded['data'];
          return data.map((e) => ScreenedChild.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch screened data');
      }
    } catch (e) {
      logger.e('Error fetching screened data: $e');
      return [];
    }
  }

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
        logger.d('Districts API Response: $decoded');

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
      logger.e('Error fetching districts: $e');
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
        logger.d('Talukas API Response: $decoded');

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
      logger.e('Error fetching talukas: $e');
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
        logger.d('Villages API Response: $decoded');

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
      logger.e('Error fetching villages: $e');
      return []; // return empty list on error
    }
  }
  // 🔹 Get Schools by GrampanchayatId

  Future<List<School>> fetchSchoolsByGrampanchayatId(
    int grampanchayatId,
  ) async {
    setState(() {
      isLoadingSchools = true;
      schoolFetchError = null;
      schools = [];
      selectedSchool = null;
    });

    try {
      final uri = Uri.parse(
        "https://api.rbsknagpur.in/api/Rbsk/GetSchoolByGrampanchayatId?grampanchayatId=$grampanchayatId",
      );

      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 180), // Add timeout
            onTimeout: () {
              throw Exception(
                'Request timed out. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        logger.d('Schools API Response: $decoded');

        if (decoded is List) {
          final fetchedSchools = decoded
              .map((e) => School.fromJson(e))
              .toList();

          setState(() {
            schools = fetchedSchools;
            isLoadingSchools = false;
          });

          return fetchedSchools;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('❌ Error fetching schools: $e');
      setState(() {
        isLoadingSchools = false;
        schoolFetchError = e.toString().contains('timeout')
            ? "Request timed out. Check internet connection."
            : "Error: $e";
      });

      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(schoolFetchError ?? 'Failed to load schools'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return [];
    }
  }
  // Mock data for school information - will be replaced with API data in future

  final List<String> classes = [
    '1st Class',
    '2st Class',
    '3st Class',
    '4st Class',
    '5st Class',
    '6st Class',
    '7st Class',
    '8st Class',
    '9st Class',
    '10st Class',
    '11st Class',
    '12st Class',
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
                    const SizedBox(height: 24),

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
                    const SizedBox(height: 24),

                    _buildRequiredLabel('Village'),
                    const SizedBox(height: 8),
                    _buildDropdown<Grampanchayat>(
                      value: selectedVillage,
                      items: villages,
                      getLabel: (village) => village.grampanchayatName,
                      onChanged: (Grampanchayat? newValue) async {
                        if (newValue == null) return;

                        setState(() {
                          selectedVillage = newValue;
                          selectedSchool = null;
                          schools = [];
                        });

                        final fetchedSchools =
                            await fetchSchoolsByGrampanchayatId(
                              newValue.grampanchayatId,
                            );

                        setState(() {
                          schools = fetchedSchools;
                          // print("fetchSchoolsByGrampanchayatId Api response: $schools");
                        });
                      },
                      hint: 'Select Village',
                    ),

                    const SizedBox(height: 24),

                    _buildRequiredLabel('School ID / DISE code'),
                    const SizedBox(height: 8),
                    _buildDropdown<School>(
                      hint: "Select School",
                      value: selectedSchool,
                      items: schools.where((s) => s.flag == 'School').toList(),
                      getLabel: (school) => school.schoolName,
                      onChanged: (School? newValue) async {
                        if (newValue == null) return;

                        setState(() {
                          selectedSchool = newValue;
                          selectedClass = null;
                          schoolDetails = null;
                          isLoadingSchoolDetails = true;
                          schoolDetailsError = null;
                        });

                        logger.d(
                          '🏫 Selected school: ${newValue.schoolName} (ID: ${newValue.schoolId})',
                        );

                        try {
                          final details = await fetchSchoolDetails(
                            newValue.schoolId,
                          );

                          setState(() {
                            schoolDetails = details;
                            isLoadingSchoolDetails = false;
                          });

                          if (details != null) {
                            logger.d(
                              '✅ School details fetched successfully for ID: ${newValue.schoolId}',
                            );
                            logger.d(
                              '📦 SchoolDetails object: ${details.toString()}',
                            );
                          } else {
                            logger.d(
                              '⚠️ fetchSchoolDetails() returned null for ID: ${newValue.schoolId}',
                            );
                          }
                        } catch (e, stack) {
                          setState(() {
                            schoolDetailsError =
                                'Failed to load school details: $e';
                            isLoadingSchoolDetails = false;
                          });
                          logger.f(
                            '❌ Exception while fetching school details: $e',
                          );
                          logger.f(stack);
                        }
                      },
                    ),

                    // Show school information and class selection only after school ID is selected
                    if (selectedSchool != null) ...[
                      const SizedBox(height: 32),
                      _buildSchoolInformation(),
                      const SizedBox(height: 10),
                      _buildClassSelection(widget.doctorId!),
                    ],
                  ],
                ),
              ),
            ),

            // Show Start Screening button only after school ID is selected
            if (selectedSchool != null) _buildStartScreeningButton(),
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

  Widget _buildSchoolInformation() {
    final schoolInfo = schoolData[selectedSchool];

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
            'School ID / DISE code : $selectedSchool',
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

  List<String> getAvailableClasses() {
    if (schoolDetails == null) return [];
    return [
      if (schoolDetails?.firstClass ?? false) '1st Class',
      if (schoolDetails?.secondClass ?? false) '2nd Class',
      if (schoolDetails?.thirdClass ?? false) '3rd Class',
      if (schoolDetails?.fourthClass ?? false) '4th Class',
      if (schoolDetails?.fifthClass ?? false) '5th Class',
      if (schoolDetails?.sixthClass ?? false) '6th Class',
      if (schoolDetails?.seventhClass ?? false) '7th Class',
      if (schoolDetails?.eighthClass ?? false) '8th Class',
      if (schoolDetails?.ninethClass ?? false) '9th Class',
      if (schoolDetails?.tenthClass ?? false) '10th Class',
      if (schoolDetails?.eleventhClass ?? false) '11th Class',
      if (schoolDetails?.twelthClass ?? false) '12th Class',
    ];
  }

  Widget _buildClassSelection(int doctorId) {
    final availableClasses = getAvailableClasses();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // School info display matching existing UI style
        Divider(color: Colors.grey[300], thickness: 1),
        const SizedBox(height: 10),
        if (selectedSchool != null && schoolDetails != null) ...[
          Text(
            'School ID / DISE code: ${selectedSchool!.schoolCode}',
            style: const TextStyle(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'School Name: ${schoolDetails!.schoolName}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Total Students: ${schoolDetails!.total}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Total Boys: ${schoolDetails!.totalNoOFBoys}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 40),
              Text(
                'Total Girls: ${schoolDetails!.totalNoOfGirls}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'Latitude: ${schoolDetails!.latitude}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                'longitude: ${schoolDetails!.longitude}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
        Divider(color: Colors.grey[300], thickness: 1),

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
                if (selectedClass == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a class first'),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentInfoScreen(
                      schoolName: selectedSchool!.schoolName,
                      teamName: widget.doctorName,
                      isSchool: true,
                      schoolId: selectedSchool!.schoolId,
                      className: selectedClass!,
                      doctorId: doctorId,
                    ),
                  ),
                );
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
        isLoadingSchoolDetails
            ? const Center(child: CircularProgressIndicator())
            : schoolDetailsError != null
            ? Text(
                schoolDetailsError!,
                style: const TextStyle(color: Colors.red),
              )
            : availableClasses.isEmpty
            ? const Text(
                'No classes available',
                style: TextStyle(color: Colors.grey),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: availableClasses.length,
                itemBuilder: (context, index) {
                  final className = availableClasses[index];
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
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey[400]!,
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
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
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
              ? () async {
                  final screenedData = await fetchScreenedData(
                    schoolId: selectedSchool!.schoolId,
                    className: selectedClass!,
                  );

                  logger.d('Screened Children: $screenedData');
                  logger.i('Selected Class: $selectedClass');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStudent(
                        className: selectedClass!,
                        schoolId: selectedSchool!.schoolId,
                        schoolName: selectedSchool!.schoolName,
                        talukaName: selectedTaluka!.talukaName,
                        talukaId: selectedTaluka!.talukaId,
                        districtName: selectedDistrict!.districtName,
                        districtId: selectedDistrict!.districtId,
                        gramPanchayatName: selectedVillage!.grampanchayatName,
                        gramPanchayatId: selectedVillage!.grampanchayatId,
                      ),
                    ),
                  );

                  // Navigate to the next screen and pass the data
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ScreeningFormScreenOne(
                  //       // school: selectedSchool!,
                  //       doctorId: widget.doctorId!,
                  //       schoolId: selectedSchool!.schoolId,
                  //       schoolName: selectedSchool!.schoolName,
                  //       doctorName: widget.doctorName,
                  //       className: selectedClass!,
                  //       // screenedChildren: screenedData,
                  //     ),
                  //   ),
                  // );
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
            'Add Student',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
