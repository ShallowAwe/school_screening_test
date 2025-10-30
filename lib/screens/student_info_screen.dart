import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:school_test/screens/anganWadi_screening-forms/anganwadi_screening_form1.dart';
import 'package:school_test/screens/home_screen.dart';
import 'package:school_test/screens/school_screnning_screens/screening_for_class_form_1.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:school_test/utils/error_popup.dart';

class StudentInfoScreen extends StatefulWidget {
  final int? schoolId;
  final String className;
  final int doctorId;
  final bool isSchool;
  final String teamName;
  final String? schoolName;

  const StudentInfoScreen({
    super.key,
    required this.schoolId,
    required this.className,
    required this.doctorId,
    required this.isSchool,
    required this.teamName,
    this.schoolName,
  });

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final _logger = Logger();
  bool isLoading = true;
  String? errorMessage;
  List<dynamic> students = [];
  List<dynamic> filteredStudents = [];

  TextEditingController searchController = TextEditingController();

  String? schoolLatitude;
  String? schoolLongitude;

  // validating Ux
  bool isValidatingLocation = false;
  @override
  void initState() {
    super.initState();
    _logger.i({
      'schoolId': widget.schoolId,
      'className': widget.className,
      'doctorId': widget.doctorId,
      'isSchool': widget.isSchool,
      'teamName': widget.teamName,
      'schoolName': widget.schoolName,
    });
    fetchSchoolLocation(); // Add this line
    fetchStudentsFromApi();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudents = List.from(students);
      } else {
        filteredStudents = students.where((student) {
          final name = student['childName']?.toString().toLowerCase() ?? '';
          final fatherName =
              student['fathersName']?.toString().toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) || fatherName.contains(searchQuery);
        }).toList();
      }
    });
  }

  String normalizeClassName(String className) {
    return className.replaceAll(' Class', '').trim();
  }

  Future<void> fetchStudentsFromApi() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.rbsknagpur.in/api/Rbsk/GetStudentsBySchoolId?SchoolId=${widget.schoolId}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> allStudents =
            (jsonResponse['students'] ?? []) as List<dynamic>;

        print("✅ Total students fetched: ${allStudents.length}");

        final normalizedClass = normalizeClassName(
          widget.className,
        ).toLowerCase();
        final classKey = _getClassKey(normalizedClass);

        final filteredByClass = allStudents
            .where((student) => student[classKey] == true)
            .toList();

        print("✅ Filtered students (${classKey}): ${filteredByClass.length}");

        setState(() {
          students = filteredByClass;
          filteredStudents = List.from(filteredByClass);
          isLoading = false;

          if (filteredByClass.isEmpty) {
            errorMessage = "No students found for ${widget.className}.";
          }
        });

        // Reapply search filter if there's text in search box
        if (searchController.text.isNotEmpty) {
          filterStudents(searchController.text);
        }
      } else {
        throw Exception("Server returned status code ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while fetching: $e");
      setState(() {
        errorMessage =
            "Failed to fetch students. Please check your connection.";
        isLoading = false;
        students = [];
        filteredStudents = [];
      });
    }
  }

  String _getClassKey(String normalizedClass) {
    switch (normalizedClass) {
      case '1st':
        return 'firstClass';
      case '2nd':
        return 'secondClass';
      case '3rd':
        return 'thirdClass';
      case '4th':
        return 'fourthClass';
      case '5th':
        return 'fifthClass';
      case '6th':
        return 'sixthClass';
      case '7th':
        return 'seventhClass';
      case '8th':
        return 'eighthClass';
      case '9th':
        return 'ninthClass';
      case '10th':
        return 'tenthClass';
      case '11th':
        return 'eleventhClass';
      case '12th':
        return 'twelthClass';
      default:
        return normalizedClass;
    }
  }

  // Haversine formula to calculate distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable location services')),
          );
        }
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return null;
        }
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _logger.e('Location error: $e');
      return null;
    }
  }

  // Verify location match
  Future<bool> verifySchoolLocation() async {
    if (schoolLatitude == null || schoolLongitude == null) {
      _logger.e('School coordinates not available');
      return false;
    }

    final currentPosition = await getCurrentLocation();
    if (currentPosition == null) return false;

    final schoolLat = double.tryParse(schoolLatitude!);
    final schoolLon = double.tryParse(schoolLongitude!);

    if (schoolLat == null || schoolLon == null) {
      _logger.e('Invalid school coordinates');
      return false;
    }

    final distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      schoolLat,
      schoolLon,
    );

    _logger.d('Distance from school: ${distance.toStringAsFixed(2)} km');

    // Allow 0.5 km radius (500 meters)
    return distance <= 0.5;
  }

  Future<void> fetchSchoolLocation() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.rbsknagpur.in/api/Rbsk/GetAllSchoolDataWithSchoolId?SchoolId=${widget.schoolId}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final schoolData = jsonResponse['schools'];

        setState(() {
          schoolLatitude = schoolData['latitude'];
          schoolLongitude = schoolData['longitude'];
        });

        _logger.d('School location: $schoolLatitude, $schoolLongitude');
      }
    } catch (e) {
      _logger.e('Error fetching school location: $e');
    }
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: searchController,
            onChanged: filterStudents,
            decoration: InputDecoration(
              hintText: 'Search by student or father name...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        searchController.clear();
                        filterStudents('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Results count indicator (when searching)
          if (searchController.text.isNotEmpty && students.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    '${filteredStudents.length} of ${students.length} students',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Body content
          Expanded(child: _buildStudentList()),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    // Error state (network error, API failure)
    if (errorMessage != null && students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red[300], size: 64),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: fetchStudentsFromApi,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // No students in this class
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off, color: Colors.blue[200], size: 64),
            const SizedBox(height: 16),
            Text(
              "No students found in ${widget.className}",
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // No search results
    if (filteredStudents.isEmpty && searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.grey[400], size: 64),
            const SizedBox(height: 16),
            Text(
              'No students found for "${searchController.text}"',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different name',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                searchController.clear();
                filterStudents('');
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Search'),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ],
        ),
      );
    }

    // Display filtered students
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return _buildStudentCard(context, student);
      },
    );
  }

  Widget _buildStudentCard(BuildContext context, Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            // Show loading snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Verifying location...'),
                  ],
                ),
                duration: const Duration(seconds: 30),
                backgroundColor: Colors.blue[700],
              ),
            );

            // Verify location before navigating
            final isLocationValid = await verifySchoolLocation();

            // Clear the loading snackbar
            ScaffoldMessenger.of(context).clearSnackBars();

            if (!isLocationValid) {
              if (mounted) {
                showErrorPopup(
                  context,
                  message:
                      "You are not at the school location. Please visit the school to proceed.",
                  isSuccess: false,
                );
              }
              return;
            }

            // Navigate based on isSchool flag
            if (widget.isSchool) {
              // Navigate to School Screening Form
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ScreeningFormScreenOne(
                    schoolName: widget.schoolName!,
                    doctorId: widget.doctorId,
                    schoolId: widget.schoolId!,
                    className: widget.className,
                    doctorName: widget.teamName,
                    childName: student['childName'],
                    aadhaarNo: student['aadhaarNo'],
                    fatherName: student['fathersName'],
                    contactNo: student['fathersContactNo'],
                    dateOfBirth: student['dateOfBirth'],
                  ),
                ),
              );
            } else {
              // Navigate to Anganwadi Screening Form
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ScreeningForAnganWadiFormOne(
                    schoolName: widget.schoolName!,
                    doctorId: widget.doctorId,
                    schoolId: widget.schoolId!,
                    className: widget.className,
                    doctorName: widget.teamName,
                    childName: student['childName'],
                    aadhaarNo: student['aadhaarNo'],
                    fatherName: student['fathersName'],
                    contactNo: student['fathersContactNo'],
                    dateOfBirth: student['dateOfBirth'],
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (student['childName']?.toString().isNotEmpty ?? false)
                          ? student['childName']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase()
                          : "?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['childName']?.toString() ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 15,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              student['fathersName']?.toString() ?? 'N/A',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildBadge(
                            icon: student['gender'] == 'Male'
                                ? Icons.male
                                : Icons.female,
                            text: student['gender']?.toString() ?? 'N/A',
                          ),
                          const SizedBox(width: 8),
                          _buildBadge(
                            icon: Icons.calendar_today,
                            text: "${student['age'] ?? 'N/A'} yrs",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  doctorId: widget.doctorId,
                  doctorName: widget.teamName,
                ),
              ),
              (route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.className,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
        actions: [
          if (!isLoading && students.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${students.length} ${students.length == 1 ? 'student' : 'students'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchStudentsFromApi,
        color: Colors.white,
        backgroundColor: Colors.blue,
        child: _buildBody(),
      ),
    );
  }
}
