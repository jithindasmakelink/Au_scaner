// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:scanner_app/botttom.dart';
// import 'package:scanner_app/main.dart';
// import 'package:scanner_app/trans.dart';

// class CreditNoteData {
//   final int month;
//   final int fiftyToken;
//   final int hundredToken;
//   final int fiftyAmount;
//   final int hundredAmount;
//   final int commission;
//   final int creditNoteAmount;
//   final int debit;
//   final String status;
//   final int year;

//   CreditNoteData({
//     required this.month,
//     required this.fiftyToken,
//     required this.hundredToken,
//     required this.fiftyAmount,
//     required this.hundredAmount,
//     required this.commission,
//     required this.creditNoteAmount,
//     required this.debit,
//     required this.status,
//     required this.year,
//   });

//   factory CreditNoteData.fromJson(Map<String, dynamic> json) {
//     return CreditNoteData(
//       month: json['month'],
//       fiftyToken: json['50_token'],
//       hundredToken: json['100_token'],
//       fiftyAmount: json['50_amt'],
//       hundredAmount: json['100_amt'],
//       commission: json['commission'],
//       creditNoteAmount: json['cn_amt'],
//       debit: json['debit'],
//       status: json['status'],
//       year: json['year'],
//     );
//   }
// }

// class CreditNoteSummary extends StatefulWidget {
//   const CreditNoteSummary({Key? key}) : super(key: key);

//   @override
//   _CreditNoteSummaryState createState() => _CreditNoteSummaryState();
// }

// class _CreditNoteSummaryState extends State<CreditNoteSummary> {
//   final TextEditingController _tokenController = TextEditingController();
//   List<CreditNoteData> transactionData = [];
//   int selectedMonth = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     var url = Uri.parse('https://olx.makelink.in/api/credit/note');
//     var token = await getAccessToken();
//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//     try {
//       var response = await http.get(
//         url,
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);
//         if (jsonData['status'] == 'success') {
//           setState(() {
//             transactionData = (jsonData['data'] as List)
//                 .map((item) => CreditNoteData.fromJson(item))
//                 .toList();
//           });
//         } else {
//           print('API request failed with status: ${jsonData['status']}');
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Credit Note Summary'),
//         centerTitle: true,
//         leading: Container(
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.white,
//           ),
//           child: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(
//                   builder: (context) => Bottom_Nav(initialIndex: 1),
//                 ),
//                 (route) => false,
//               );
//             },
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: transactionData.length,
//               itemBuilder: (context, index) {
//                 var transaction = transactionData[index];
//                 return Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Month: ${transaction.year}',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   selectedMonth = transaction.month;
//                                 });
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         TransactionHistoryPage(
//                                       selectedMonth: selectedMonth,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF788AEA),
//                               ),
//                               child: const Text(
//                                 'View History',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Token of ₹ 50:'),
//                             Text('${transaction.fiftyToken}'),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Token of ₹ 100:'),
//                             Text('${transaction.hundredToken}'),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('50 Amount:'),
//                             Text('${transaction.fiftyAmount}'),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('100 Amount:'),
//                             Text('${transaction.hundredAmount}'),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Commission:'),
//                             Text('${transaction.commission}'),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Credit Note Amount:',
//                               style: TextStyle(color: Colors.green),
//                             ),
//                             Text(
//                               '${transaction.creditNoteAmount}',
//                               style: const TextStyle(color: Colors.green),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Debit:'),
//                             Text('${transaction.debit}'),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Status:',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                             Text(
//                               '${transaction.status}',
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Year:'),
//                             Text('${transaction.year}'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tokenController.dispose();
//     super.dispose();
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scanner_app/botttom.dart';
import 'package:scanner_app/main.dart';
import 'package:scanner_app/trans.dart';

class CreditNoteData {
  final int month;
  final int fiftyToken;
  final int hundredToken;
  final int fiftyAmount;
  final int hundredAmount;
  final int commission;
  final int creditNoteAmount;
  final int debit;
  final String status;
  final int year;

  CreditNoteData({
    required this.month,
    required this.fiftyToken,
    required this.hundredToken,
    required this.fiftyAmount,
    required this.hundredAmount,
    required this.commission,
    required this.creditNoteAmount,
    required this.debit,
    required this.status,
    required this.year,
  });

  factory CreditNoteData.fromJson(Map<String, dynamic> json) {
    return CreditNoteData(
      month: json['month'],
      fiftyToken: json['50_token'],
      hundredToken: json['100_token'],
      fiftyAmount: json['50_amt'],
      hundredAmount: json['100_amt'],
      commission: json['commission'],
      creditNoteAmount: json['cn_amt'],
      debit: json['debit'],
      status: json['status'],
      year: json['year'],
    );
  }
}

class CreditNoteSummary extends StatefulWidget {
  const CreditNoteSummary({Key? key}) : super(key: key);

  @override
  _CreditNoteSummaryState createState() => _CreditNoteSummaryState();
}

String getMonthName(int monthNumber) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return monthNames[monthNumber - 1];
}

class _CreditNoteSummaryState extends State<CreditNoteSummary> {
  final TextEditingController _tokenController = TextEditingController();
  List<CreditNoteData> transactionData = [];
  int selectedMonth = 0;
  int balance = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://olx.makelink.in/api/credit/note');
    var token = await getAccessToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      var response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            transactionData = (jsonData['data'] as List)
                .map((item) => CreditNoteData.fromJson(item))
                .toList();
            balance = jsonData['balance'];
          });
        } else {
          print('API request failed with status: ${jsonData['status']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Credit Note Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Balance',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹ $balance',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactionData.length,
              itemBuilder: (context, index) {
                var transaction = transactionData[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${getMonthName(transaction.month)}', // Displaying month name
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '- ${transaction.year}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedMonth = transaction.month;
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TransactionHistoryPage(
                                      selectedMonth: selectedMonth,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF788AEA),
                              ),
                              child: const Text(
                                'View History',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Token of ₹ 50:'),
                            Text('${transaction.fiftyToken}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Token of ₹ 100:'),
                            Text('${transaction.hundredToken}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('50 Amount:'),
                            Text('${transaction.fiftyAmount}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('100 Amount:'),
                            Text('${transaction.hundredAmount}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Commission:'),
                            Text('${transaction.commission}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Credit Note Amount:',
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(
                              '${transaction.creditNoteAmount}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Debit:'),
                            Text('${transaction.debit}'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Status:',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${transaction.status}',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }
}
