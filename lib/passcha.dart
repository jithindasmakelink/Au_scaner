import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scanner_app/botttom.dart';
import 'package:scanner_app/main.dart';

class PasswordResponseModel {
  final String message;
  final int status;

  PasswordResponseModel({
    required this.message,
    required this.status,
  });

  factory PasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return PasswordResponseModel(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}

class PasswordRequestModel {
  // ignore: non_constant_identifier_names
  final String old_password;
  // ignore: non_constant_identifier_names
  final String new_password;

  PasswordRequestModel({
    // ignore: non_constant_identifier_names
    required this.old_password,
    // ignore: non_constant_identifier_names
    required this.new_password,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': old_password.trim(),
      'new_password': new_password.trim(),
    };
  }
}

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureOldText = true;
  bool _obscureNewText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _oldPasswordController,
                    hintText: 'Enter your old password',
                    description: 'Old Password:',
                    obscureText: _obscureOldText,
                    onTap: () {
                      setState(() {
                        _obscureOldText = !_obscureOldText;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _newPasswordController,
                    hintText: 'Enter your new password',
                    description: 'New Password:',
                    obscureText: _obscureNewText,
                    onTap: () {
                      setState(() {
                        _obscureNewText = !_obscureNewText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 140,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _changePassword();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF556CE4),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;

      // Create the request model
      PasswordRequestModel requestModel = PasswordRequestModel(
        old_password: oldPassword,
        new_password: newPassword,
      );

      // Send the request
      _sendChangePasswordRequest(requestModel);
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String description,
    required bool obscureText,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: onTap,
                  child: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              obscureText: obscureText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  void _sendChangePasswordRequest(PasswordRequestModel requestModel) async {
    var uri = Uri.parse('https://olx.makelink.in/api/change/password');
    var newUrl = uri.replace(queryParameters: {
      'old_password': requestModel.old_password,
      'new_password': requestModel.new_password,
    });
    var token = await getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest('POST', newUrl);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var parsedResponse = json.decode(responseBody);
      var passwordResponse = PasswordResponseModel.fromJson(parsedResponse);
      print(
          'Status: ${passwordResponse.status}, Message: ${passwordResponse.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(passwordResponse.message),
      ));

      // Update index to navigate to home page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Bottom_Nav(initialIndex: 1),
        ),
        (route) => false,
      );
    } else {
      print(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to change password. Please try again.'),
      ));
    }
  }
}
