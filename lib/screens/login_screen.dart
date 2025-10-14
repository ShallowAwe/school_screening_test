import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_test/config/api_config.dart';
import 'package:school_test/config/endpoints.dart';
import 'package:school_test/models/user_model.dart';
import 'package:school_test/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:school_test/utils/error_popup.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final String baseUrl = ApiConfig.baseUrl;
  final String endpoint = Endpoints.doctorLogin;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['success'] == true && json['doctorData'] != null) {
        final Doctor doctor = Doctor.fromJson(json['doctorData']);
        final String message = json['responseMessage'] ?? 'Login successful!';

        _showSnackBar(message);
        showErrorPopup(context, isSuccess: true, message: "Login successful.");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                doctorId: doctor.doctorId,
                doctorName: doctor.doctorName,
              ),
            ),
          );
        });
      } else {
        // _showSnackBar(json['responseMessage'] ?? 'Login failed');
        showErrorPopup(
          context,
          isSuccess: false,
          message: "Login failed. Please check your credentials and try again.",
        );
      }
    } else {
      final Map<String, dynamic> errorJson = jsonDecode(response.body);
      // _showSnackBar(errorJson['responseMessage'] ?? 'Login failed');
      showErrorPopup(
        context,
        isSuccess: false,
        message: "Login failed. Please check your credentials and try again.",
      );
    }
  }

  void _handleSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Please enter your Team ID');
      return;
    }

    if (password.isEmpty) {
      _showSnackBar('Please enter your password');
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await login(email, password);
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: Text('Your privacy policy content goes here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Responsive spacing
    final topSpacing = keyboardVisible
        ? size.height * 0.02
        : size.height * 0.05;
    final titleSpacing = keyboardVisible ? 8.0 : 16.0;
    final contentSpacing = keyboardVisible
        ? size.height * 0.03
        : size.height * 0.08;
    final fieldSpacing = keyboardVisible ? 16.0 : 24.0;
    final buttonSpacing = keyboardVisible ? 24.0 : 40.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF2E7DD8)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.06,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: topSpacing),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: size.width * 0.25,
                                  child: Image.asset(
                                    'assets/images/rbskLogo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: contentSpacing * 2),
                                Text(
                                  "Doctor's Login",
                                  style: TextStyle(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                // SizedBox(height: titleSpacing),
                                //
                                // Team ID field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Team ID',
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        enabled: !_isLoading,
                                        decoration: InputDecoration(
                                          hintText: 'Enter Your Team ID',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: size.width * 0.04,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: fieldSpacing),
                                // Password field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        textInputAction: TextInputAction.done,
                                        enabled: !_isLoading,
                                        onSubmitted: (_) => _handleSignIn(),
                                        decoration: InputDecoration(
                                          hintText: 'Enter password',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: size.width * 0.04,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Color(0xFF4A90E2),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: buttonSpacing),
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _handleSignIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF1E3A8A),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      disabledBackgroundColor: Color(
                                        0xFF1E3A8A,
                                      ).withOpacity(0.6),
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: size.width * 0.045,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!keyboardVisible) ...[
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: _showPrivacyPolicy,
                              child: Text(
                                'Application privacy policy',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(204),
                                  fontSize: size.width * 0.035,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
