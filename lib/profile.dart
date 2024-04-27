import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:scanner_app/botttom.dart';
import 'package:scanner_app/main.dart';
import 'package:scanner_app/passcha.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Request Model
class LogoutRequest {
  final String dealerCode;
  final String password;

  LogoutRequest({required this.dealerCode, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'dealerCode': dealerCode,
      'password': password,
    };
  }
}

class LogoutResponseModel {
  final int status;
  final String message;

  LogoutResponseModel({required this.status, required this.message});

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('user_name');
    String? userMobile = prefs.getString('user_mobile');
    if (userName != null) {
      _nameController.text = userName;
    }
    if (userMobile != null) {
      _phoneController.text = userMobile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
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
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Bottom_Nav(initialIndex: 1),
                ),
                (route) => false,
              );
            },
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _showLogoutConfirmationDialog();
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        child: CircleAvatar(
                          radius: 57,
                          backgroundImage: AssetImage('lib/assest/ani.jpg'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt_outlined),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                getPhoto();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    description: 'Name:',
                    iconData: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextFormField(
                    controller: _phoneController,
                    hintText: 'Enter your mobile number',
                    description: 'Mobile Number:',
                    iconData: Icons.phone,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            Get.to(const PasswordChange());
                          },
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all<Color>(
                  //         const Color(0xFF556CE4),
                  //       ),
                  //       minimumSize: MaterialStateProperty.all<Size>(
                  //         const Size(double.infinity, 50),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Add Student',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String description,
    required IconData iconData,
    int? maxLength,
    TextInputType? keyboardType,
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
            child: Row(
              children: [
                Icon(iconData),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                    ),
                    maxLength: maxLength,
                    keyboardType: keyboardType,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  File? _photo;
  Future<void> getPhoto() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo == null) {
      return;
    } else {
      final photoTemp = File(photo.path);
      _photo = photoTemp;
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            _logout();
          },
          child: const Text("Logout"),
        ),
      ],
    );
  }

  Future<void> _logout() async {
    var url = Uri.parse('https://olx.makelink.in/api/logout');
    var token = await getAccessToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var requestModel = LogoutRequest(dealerCode: '1234567', password: 'admin');
    var requestBody = jsonEncode(requestModel.toJson());

    try {
      var response = await http.post(url, headers: headers, body: requestBody);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var logoutResponse = LogoutResponseModel.fromJson(responseBody);
        print(
            'Logout successful. Status: ${logoutResponse.status}, Message: ${logoutResponse.message}');
        Get.off(Log());
      } else {
        print('Logout failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Logout failed. Exception: $e');
    }
  }
}
