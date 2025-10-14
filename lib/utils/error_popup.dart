import 'package:flutter/material.dart';

Future<void> showErrorPopup(BuildContext context, {String? message, bool? isSuccess}) async {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final popupWidth = screenWidth * 0.8;
  final popupHeight = screenHeight * 0.25;

  // Show dialog
  showDialog(
    context: context,
    barrierDismissible: false, // Disable tap outside
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: popupWidth,
        height: popupHeight,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess == false
                    ? Icons.error_outline
                    : Icons.check_circle_outline,
                color: isSuccess == false ? Colors.redAccent : Colors.green,
                size: popupHeight * 0.35,
              ),
              const SizedBox(height: 16),
              Text(
                message ?? "Unable to fetch data.\nPlease try again later.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Auto-close after 1 second
  await Future.delayed(const Duration(seconds: 1));
  if (context.mounted) Navigator.of(context).pop();
}
