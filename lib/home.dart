// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:scanner_app/main.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController tokenController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String responseMessage = '';

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Token Scanner',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           actions: [
//             GestureDetector(
//               onTap: () async {
//                 var status = await Permission.camera.request();
//                 if (status.isGranted) {
//                   // Camera permission granted, handle accordingly
//                 } else {
//                   // Permission denied, handle accordingly
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   'assets/qr.png',
//                   width: 24,
//                   height: 24,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Form(
//           key: formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(height: 20),
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Enter Token:',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Color(0xFF5B72E5),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextFormField(
//                   controller: tokenController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(25.0),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a token';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: SizedBox(
//                   width: 100,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       print('Button pressed');
//                       if (validateAndSave()) {
//                         await submitToken();
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF5B72E5),
//                     ),
//                     child: const Text(
//                       'Submit',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                   height:
//                       20), // Add some space between button and response message
//               Text(
//                 responseMessage, // Display response message here
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors
//                       .green, // You can change color as per your preference
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool validateAndSave() {
//     final form = formKey.currentState;
//     if (form != null) {
//       print('Form is not null');
//       if (form.validate()) {
//         form.save();
//         print('Form saved');
//         return true;
//       } else {
//         print('Validation failed');
//         return false;
//       }
//     } else {
//       print('Form is null');
//       return false;
//     }
//   }

//   Future<void> submitToken() async {
//     var request = http.MultipartRequest(
//         'POST', Uri.parse('https://olx.makelink.in/api/scan/token'));
//     request.fields.addAll({
//       'token': tokenController.text,
//     });
//     var token = await getAccessToken();
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     request.headers.addAll(headers);

//     try {
//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         var responseBody = await response.stream.bytesToString();
//         setState(() {
//           responseMessage = responseBody;
//         });
//         print(responseBody);
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(
//                 "Success",
//                 style: TextStyle(color: Colors.green),
//               ),
//               content: const Text(
//                 "Token submitted successfully!",
//                 style: TextStyle(color: Colors.blue),
//               ),
//               backgroundColor: Colors.yellow,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     "OK",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         setState(() {
//           responseMessage = 'Failed with status code: ${response.statusCode}';
//         });
//         print('Failed with status code: ${response.statusCode}');
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               backgroundColor: Colors.white,
//               title: const Text(
//                 "Error",
//                 style: TextStyle(color: Colors.red), // Set title text color
//               ),
//               titleTextStyle: const TextStyle(
//                 fontWeight: FontWeight.bold, // Set title text style
//               ),
//               content: Text(
//                 "Failed to submit token. Status code: ${response.statusCode}",
//                 style: TextStyle(color: Colors.black), // Set content text color
//               ),
//               contentTextStyle: const TextStyle(
//                 fontSize: 16, // Set content text size
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     "OK",
//                     style:
//                         TextStyle(color: Colors.white), // Set button text color
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(
//                         Colors.black), // Set button background color
//                     padding: MaterialStateProperty.all(
//                         EdgeInsets.all(10)), // Set button padding
//                     shape: MaterialStateProperty.all(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                             10), // Set button border radius
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } catch (e) {
//       setState(() {
//         responseMessage = 'Error: $e';
//       });
//       print('Error: $e');
//       showDialog(
//         // ignore: use_build_context_synchronously
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text("Error"),
//             content: Text("An error occurred: $e"),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:scanner_app/main.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController tokenController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String responseMessage = '';
  var getResult = 'QR Code Result';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Token Scanner',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () async {
                var status = await Permission.camera.request();
                if (status.isGranted) {
                  scanQRCode();
                } else {
                  // Permission denied, handle accordingly
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/qr.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Token:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5B72E5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: tokenController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a token';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      print('Button pressed');
                      if (validateAndSave()) {
                        await submitToken();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B72E5),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      20), // Add some space between button and response message
              Text(
                responseMessage, // Display response message here
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors
                      .green, // You can change color as per your preference
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                getResult, // Display response message here
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color:
                      Colors.red, // You can change color as per your preference
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null) {
      print('Form is not null');
      if (form.validate()) {
        form.save();
        print('Form saved');
        return true;
      } else {
        print('Validation failed');
        return false;
      }
    } else {
      print('Form is null');
      return false;
    }
  }

  Future<void> submitToken() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://olx.makelink.in/api/scan/token'));
    request.fields.addAll({
      'token': tokenController.text,
    });
    var token = await getAccessToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        setState(() {
          responseMessage = responseBody;
        });
        print(responseBody);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Success",
                style: TextStyle(color: Colors.green),
              ),
              content: const Text(
                "Token submitted successfully!",
                style: TextStyle(color: Colors.blue),
              ),
              backgroundColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          responseMessage = 'Failed with status code: ${response.statusCode}';
        });
        print('Failed with status code: ${response.statusCode}');
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Error",
                style: TextStyle(color: Colors.red), // Set title text color
              ),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, // Set title text style
              ),
              content: Text(
                "Failed to submit token. Status code: ${response.statusCode}",
                style: const TextStyle(
                    color: Colors.black), // Set content text color
              ),
              contentTextStyle: const TextStyle(
                fontSize: 16, // Set content text size
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.black), // Set button background color
                    padding: MaterialStateProperty.all(
                        EdgeInsets.all(10)), // Set button padding
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Set button border radius
                      ),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style:
                        TextStyle(color: Colors.white), // Set button text color
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      setState(() {
        responseMessage = 'Error: $e';
      });
      print('Error: $e');
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("An error occurred: $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (!mounted) return;

      setState(() {
        getResult = qrCode;
      });
      print("QRCode_Result:--");
      print(qrCode);
    } on PlatformException {
      getResult = 'Failed to scan QR Code.';
    }
  }
}
