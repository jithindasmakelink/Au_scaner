import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scanner_app/botttom.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF788AEA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/AGGRAWALLOGOsplash.png',
                      height: 150,
                      width: 150,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Instant Scanner",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Optical Character",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Reading Device",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        Get.off(Log());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Let's Get Started",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B72E5),
                          ),
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
    );
  }
}

class LoginRequestModel {
  String dealerCode;
  String password;

  LoginRequestModel({
    required this.dealerCode,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'dealerCode': dealerCode.trim(),
      'password': password.trim(),
    };
  }
}

class LoginResponseModel {
  int userId;
  String name;
  String mobile;
  String email;
  String token;
  String error;

  LoginResponseModel({
    required this.userId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.token,
    this.error = '',
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      userId: json['data']['user_id'] ?? 0,
      name: json['data']['name'] ?? '',
      mobile: json['data']['mobile'] ?? '',
      email: json['data']['email'] ?? '',
      token: json['data']['token'] ?? '',
    );
  }
}

class ApiService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    var url = Uri.parse('https://olx.makelink.in/api/login');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(requestModel.toJson());

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey('data')) {
          var loginResponse = LoginResponseModel.fromJson(jsonResponse);
          await storeUserInfo(loginResponse.name, loginResponse.mobile);
          return loginResponse;
        } else if (jsonResponse.containsKey('error')) {
          return LoginResponseModel(
            userId: 0,
            name: '',
            mobile: '',
            email: '',
            token: '',
            error: jsonResponse['error'].toString(),
          );
        }
      }
      throw Exception('Failed to load data');
    } catch (e) {
      throw Exception('Failed to load data. Exception: $e');
    }
  }

  Future<void> storeUserInfo(String name, String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_mobile', mobile);
  }
}

class Log extends StatefulWidget {
  const Log({Key? key}) : super(key: key);

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late LoginRequestModel requestModel;
  late String errorMessage = '';

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel(dealerCode: '', password: '');
  }

  Future<void> login() async {
    ApiService apiService = ApiService();
    try {
      LoginResponseModel response = await apiService.login(requestModel);
      if (response.token.isNotEmpty) {
        await storeAccessToken(response.token);
        Get.off(Bottom_Nav(
          initialIndex: 1,
        ));
        print("Login successful");
      } else if (response.error.isNotEmpty) {
        setState(() {
          errorMessage = response.error;
        });
      } else {
        print("Dealer code not found");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/AGGRAWALLOGO.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Instant Scanner",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B72E5),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Welcome To",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  "Please login to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ID';
                    }
                    return null;
                  },
                  onSaved: (input) => requestModel.dealerCode = input!,
                  decoration: InputDecoration(
                    hintText: 'Enter your ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: const Icon(Icons.person_outline_outlined),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (input) => requestModel.password = input!,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (validateAndSave()) {
                      login();
                      // Get.off(Bottom_Nav());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B72E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

Future<void> storeAccessToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
}

Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}
