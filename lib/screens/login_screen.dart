import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:school_test/config/api_config.dart';
import 'package:school_test/models/user_model.dart';
import 'package:school_test/screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:school_test/utils/error_popup.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final String baseUrl = ApiConfig.baseUrl;
  // FIX: Update this to match the correct endpoint
  final String endpoint =
      "/api/Rbsk/DoctorLogin"; // Changed from Endpoints.teamLogin

  final logger = Logger();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse("$baseUrl$endpoint");
    logger.i("Attempting login at $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      logger.i("Response Status: ${response.statusCode}");
      logger.d("Raw Response Body: ${response.body}");

      // FIX: Handle empty response body
      if (response.body.isEmpty) {
        logger.e("Empty response body received");
        showErrorPopup(
          context,
          isSuccess: false,
          message: "Server returned empty response. Please try again.",
        );
        return;
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        logger.d("Parsed JSON: $json");

        // FIX: Changed from 'teamData' to 'doctorData'
        if (json['success'] == true && json['doctorData'] != null) {
          final doctorData = json['doctorData'];

          // Extract team information from nested structure
          final teamData = doctorData['team'];

          if (teamData != null) {
            final User team = User.fromJson(teamData);
            final String message =
                json['responseMessage']?.toString() ?? 'Login successful!';
            logger.i("Login success for ${team.teamName}");
            logger.d("Team Data: $teamData");
            logger.d("Doctor Name: ${team.doctorname}");
            showErrorPopup(context, isSuccess: true, message: message);

            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      doctorId: team.teamId,
                      doctorName: team.doctorname,
                    ),
                  ),
                );
              }
            });
          } else {
            logger.w("Team data not found in response");
            showErrorPopup(
              context,
              isSuccess: false,
              message: "Team information not available.",
            );
          }
        } else {
          logger.w("Login failed: ${json['responseMessage']}");
          showErrorPopup(
            context,
            isSuccess: false,
            message:
                json['responseMessage']?.toString() ??
                "Login failed. Please check your credentials and try again.",
          );
        }
      } else {
        try {
          final Map<String, dynamic> errorJson = jsonDecode(response.body);
          logger.e("Server error ${response.statusCode}", error: errorJson);
          showErrorPopup(
            context,
            isSuccess: false,
            message:
                errorJson['responseMessage']?.toString() ??
                "Login failed. Please check your credentials and try again.",
          );
        } catch (e) {
          logger.e("Server error ${response.statusCode}", error: e);
          showErrorPopup(
            context,
            isSuccess: false,
            message:
                "Login failed. Please check your credentials and try again.",
          );
        }
      }
    } catch (e, s) {
      logger.e("Exception during login", error: e, stackTrace: s);
      showErrorPopup(
        context,
        isSuccess: false,
        message: "An error occurred. Please try again.",
      );
    }
  }

  void _handleSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }

    if (password.isEmpty) {
      _showSnackBar('Please enter your password');
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      await login(email, password);
    } catch (e, s) {
      logger.e("Error during sign-in", error: e, stackTrace: s);
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
          title: const Text('Privacy Policy'),
          content: const Text('Your privacy policy content goes here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final keyboardVisible = keyboardHeight > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF2E7DD8)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: keyboardVisible ? 16 : 24,
                  ),
                  child: Column(
                    mainAxisAlignment: keyboardVisible
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top spacing - only when keyboard is hidden
                      if (!keyboardVisible)
                        SizedBox(height: size.height * 0.05)
                      else
                        const SizedBox(height: 16),

                      // Logo - smaller when keyboard visible
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: keyboardVisible
                            ? size.width * 0.20
                            : size.width * 0.30,
                        child: Image.asset(
                          'assets/images/rbskLogo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: keyboardVisible ? 16 : size.height * 0.04,
                      ),

                      // Title
                      Text(
                        "Doctors Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: keyboardVisible
                              ? size.width * 0.05
                              : size.width * 0.06,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(height: keyboardVisible ? 20 : 32),

                      // Email Field
                      _buildInputField(
                        context: context,
                        label: 'Email',
                        hint: 'Enter Your Email ID',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        size: size,
                      ),

                      SizedBox(height: keyboardVisible ? 16 : 24),

                      // Password Field
                      _buildPasswordField(context: context, size: size),

                      SizedBox(height: keyboardVisible ? 24 : 32),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBackgroundColor: const Color(
                              0xFF1E3A8A,
                            ).withAlpha(153),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
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

                      // Privacy Policy - only show when keyboard hidden
                      if (!keyboardVisible) ...[
                        const Spacer(),
                        TextButton(
                          onPressed: _showPrivacyPolicy,
                          child: Text(
                            'Application privacy policy',
                            style: TextStyle(
                              color: Colors.white.withAlpha(204),
                              fontSize: size.width * 0.040,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for input fields
  Widget _buildInputField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            enabled: !_isLoading,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: size.width * 0.04,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method for password field
  Widget _buildPasswordField({
    required BuildContext context,
    required Size size,
  }) {
    return Column(
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
        const SizedBox(height: 8),
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
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF4A90E2),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
