import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();

  static const String _boxName = 'school_children';
  Box? _studentsBox;

  DatabaseService._constructor();

  static Future<void> init() async {
    await Hive.initFlutter();
  }

  // Add this temporary debug method to DatabaseService
  Future<void> debugPrintAllStudents() async {
    final box = await getBox();
    print("📊 Total students in database: ${box.length}");

    for (var i = 0; i < box.length; i++) {
      final student = box.getAt(i);
      print("Student $i: $student");
    }
  }

  Future<Box> getBox() async {
    if (_studentsBox != null && _studentsBox!.isOpen) {
      return _studentsBox!;
    }
    _studentsBox = await Hive.openBox(_boxName);
    return _studentsBox!;
  }

  Future<int> addStudent(Map<String, dynamic> studentData) async {
    final box = await getBox();

    // Store data exactly as received (no conversions)
    final dataToStore = Map<String, dynamic>.from(studentData);

    // Use Hive's auto-generated key as ID
    final key = await box.add(dataToStore);
    dataToStore['id'] = key;
    await box.put(key, dataToStore);

    return key;
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final box = await getBox();
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<List<Map<String, dynamic>>> getStudentsBySchoolAndClass(
    int schoolId,
    String className,
  ) async {
    final box = await getBox();

    final classMap = {
      "1st": "firstClass",
      "First": "firstClass",
      "2nd": "secondClass",
      "Second": "secondClass",
      "3rd": "thirdClass",
      "Third": "thirdClass",
      "4th": "fourthClass",
      "Fourth": "fourthClass",
      "5th": "fifthClass",
      "Fifth": "fifthClass",
      "6th": "sixthClass",
      "Sixth": "sixthClass",
      "7th": "seventhClass",
      "Seventh": "seventhClass",
      "8th": "eighthClass",
      "Eighth": "eighthClass",
      "9th": "ninthClass",
      "Ninth": "ninthClass",
      "10th": "tenthClass",
      "Tenth": "tenthClass",
      "11th": "eleventhClass",
      "Eleventh": "eleventhClass",
      "12th": "twelfthClass",
      "Twelfth": "twelfthClass",
    };

    final classColumn = classMap[className.trim()];

    if (classColumn == null) {
      throw Exception('Invalid class name: $className');
    }

    final results = box.values
        .where((student) {
          final studentMap = student as Map;
          return studentMap['schoolId'] == schoolId &&
              studentMap[classColumn] == true; // Only check for true
        })
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    return results;
  }

  Future<void> closeBox() async {
    await _studentsBox?.close();
  }
}
