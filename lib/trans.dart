// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:scanner_app/main.dart';

// class TransactionHistoryResponse {
//   final List<Transaction> transactions;
//   final int? currentPage;
//   final int? totalCount;
//   final String? nextPageUrl;
//   final String? prevPageUrl;
//   final int? perPage;
//   final int? lastPage;

//   TransactionHistoryResponse({
//     required this.transactions,
//     required this.currentPage,
//     required this.totalCount,
//     this.nextPageUrl,
//     this.prevPageUrl,
//     required this.perPage,
//     required this.lastPage,
//   });

//   factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
//     var list = json['data']['list'] as List;
//     List<Transaction> transactions =
//         list.map((transaction) => Transaction.fromJson(transaction)).toList();

//     return TransactionHistoryResponse(
//       transactions: transactions,
//       currentPage: json['data']['currentPage'] ?? '',
//       totalCount: json['data']['totalcount'] ?? '',
//       nextPageUrl: json['data']['next_page_url'] ?? '',
//       prevPageUrl: json['data']['prev_page_url'] ?? '',
//       perPage: json['data']['per_page'] ?? '',
//       lastPage: json['data']['last_page'] ?? '',
//     );
//   }
// }

// class Transaction {
//   final int id;
//   final String token;
//   final String tokenId;
//   final int? numberOf50Token;
//   final int? numberOf100Token;
//   final int tokenValue;
//   final String side;
//   final String userId;
//   final int mobileNumber;
//   final String scanPersonName;
//   final String? remarks;
//   final String createdAt;
//   final String updatedAt;

//   Transaction({
//     required this.id,
//     required this.token,
//     required this.tokenId,
//     this.numberOf50Token,
//     this.numberOf100Token,
//     required this.tokenValue,
//     required this.side,
//     required this.userId,
//     required this.mobileNumber,
//     required this.scanPersonName,
//     this.remarks,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Transaction.fromJson(Map<String, dynamic> json) {
//     return Transaction(
//       id: json['id'],
//       token: json['token'],
//       tokenId: json['tokenId'],
//       numberOf50Token: json['numberOf50Token'] as int?,
//       numberOf100Token: json['numberOf100Token'] as int?,
//       tokenValue: json['tokenValue'],
//       side: json['side'],
//       userId: json['userId'],
//       mobileNumber: json['mobileNumber'],
//       scanPersonName: json['scanPersonName'],
//       remarks: json['remarks'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//     );
//   }
// }

// class TransactionHistoryPage extends StatefulWidget {
//   final int selectedMonth;

//   const TransactionHistoryPage({Key? key, required this.selectedMonth})
//       : super(key: key);

//   @override
//   _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
// }

// class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
//   Future<TransactionHistoryResponse>? _futureTransactionHistory;

//   @override
//   void initState() {
//     super.initState();
//     _futureTransactionHistory = fetchTransactionHistory(widget.selectedMonth);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transaction History'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<TransactionHistoryResponse>(
//         future: _futureTransactionHistory,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             if (snapshot.data!.transactions.isEmpty) {
//               return Center(child: Text('No transactions available'));
//             }
//             return ListView.builder(
//               itemCount: snapshot.data!.transactions.length,
//               itemBuilder: (context, index) {
//                 var transaction = snapshot.data!.transactions[index];
//                 return TransactionUI(
//                   id: transaction.id,
//                   token: transaction.token,
//                   tokenId: transaction.tokenId,
//                   numberOf50Token: transaction.numberOf50Token,
//                   numberOf100Token: transaction.numberOf100Token,
//                   tokenValue: transaction.tokenValue,
//                   side: transaction.side,
//                   userId: transaction.userId,
//                   mobileNumber: transaction.mobileNumber,
//                   scanPersonName: transaction.scanPersonName,
//                   remarks: transaction.remarks,
//                   createdAt: transaction.createdAt,
//                   updatedAt: transaction.updatedAt,
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }

//   Future<TransactionHistoryResponse> fetchTransactionHistory(
//       int selectedMonth) async {
//     final url = Uri.parse('https://olx.makelink.in/api/transaction/history');
//     var token = await getAccessToken();

//     var headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     var queryParams = {
//       'month': selectedMonth.toString(),
//       'year': DateTime.now().year.toString(),
//     };

//     final uri = Uri.https(url.authority, url.path, queryParams);

//     try {
//       var response = await http.get(
//         uri,
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         print('Response body: ${response.body}'); // Print response body
//         return TransactionHistoryResponse.fromJson(json.decode(response.body));
//       } else {
//         throw Exception('Failed to load transaction history');
//       }
//     } catch (e) {
//       throw Exception('Failed to load transaction history: $e');
//     }
//   }
// }

// class TransactionUI extends StatelessWidget {
//   final int id;
//   final String token;
//   final String tokenId;
//   final int? numberOf50Token;
//   final int? numberOf100Token;
//   final int tokenValue;
//   final String side;
//   final String userId;
//   final int mobileNumber;
//   final String scanPersonName;
//   final String? remarks;
//   final String createdAt;
//   final String updatedAt;

//   TransactionUI({
//     required this.id,
//     required this.token,
//     required this.tokenId,
//     this.numberOf50Token,
//     this.numberOf100Token,
//     required this.tokenValue,
//     required this.side,
//     required this.userId,
//     required this.mobileNumber,
//     required this.scanPersonName,
//     this.remarks,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       child: Padding(
//         padding: EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'ID: $id',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text('Token: $token'),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Token ID: $tokenId'),
//                 Text('Token Value: $tokenValue'),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Side: $side'),
//                 Text('User ID: $userId'),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Mobile Number: $mobileNumber'),
//                 Text('Scan Person Name: $scanPersonName'),
//               ],
//             ),
//             if (numberOf50Token != null)
//               Text('Number of 50 Tokens: $numberOf50Token'),
//             if (numberOf100Token != null)
//               Text('Number of 100 Tokens: $numberOf100Token'),
//             if (remarks != null) Text('Remarks: $remarks'),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Created At: $createdAt'),
//                 Text('Updated At: $updatedAt'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scanner_app/main.dart';

class TransactionHistoryResponse {
  final List<Transaction> transactions;
  final int? currentPage;
  final int? totalCount;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int? perPage;
  final int? lastPage;

  TransactionHistoryResponse({
    required this.transactions,
    required this.currentPage,
    required this.totalCount,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.perPage,
    required this.lastPage,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['list'] as List;
    List<Transaction> transactions =
        list.map((transaction) => Transaction.fromJson(transaction)).toList();

    return TransactionHistoryResponse(
      transactions: transactions,
      currentPage: json['data']['currentPage'] ?? '',
      totalCount: json['data']['totalcount'] ?? '',
      nextPageUrl: json['data']['next_page_url'] ?? '',
      prevPageUrl: json['data']['prev_page_url'] ?? '',
      perPage: json['data']['per_page'] ?? '',
      lastPage: json['data']['last_page'] ?? '',
    );
  }
}

class Transaction {
  final int id;
  final String token;
  final String tokenId;
  final int? numberOf50Token;
  final int? numberOf100Token;
  final int tokenValue;
  final String side;
  final String userId;
  final int mobileNumber;
  final String scanPersonName;
  final String? remarks;
  final String createdAt;
  final String updatedAt;

  Transaction({
    required this.id,
    required this.token,
    required this.tokenId,
    this.numberOf50Token,
    this.numberOf100Token,
    required this.tokenValue,
    required this.side,
    required this.userId,
    required this.mobileNumber,
    required this.scanPersonName,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      token: json['token'],
      tokenId: json['tokenId'],
      numberOf50Token: json['numberOf50Token'] as int?,
      numberOf100Token: json['numberOf100Token'] as int?,
      tokenValue: json['tokenValue'],
      side: json['side'],
      userId: json['userId'],
      mobileNumber: json['mobileNumber'],
      scanPersonName: json['scanPersonName'],
      remarks: json['remarks'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class TransactionHistoryPage extends StatefulWidget {
  final int selectedMonth;

  const TransactionHistoryPage({super.key, required this.selectedMonth});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  Future<TransactionHistoryResponse>? _futureTransactionHistory;

  @override
  void initState() {
    super.initState();
    _futureTransactionHistory = fetchTransactionHistory(widget.selectedMonth);
  }

  void _showNoDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Data Available'),
          content:
              const Text('There are no transactions to display at the moment.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<TransactionHistoryResponse>(
        future: _futureTransactionHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (snapshot.data!.transactions.isEmpty) {
              return const Center(child: Text('No transactions available'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.transactions.length,
              itemBuilder: (context, index) {
                var transaction = snapshot.data!.transactions[index];
                return TransactionUI(
                  id: transaction.id,
                  token: transaction.token,
                  tokenId: transaction.tokenId,
                  numberOf50Token: transaction.numberOf50Token,
                  numberOf100Token: transaction.numberOf100Token,
                  tokenValue: transaction.tokenValue,
                  side: transaction.side,
                  userId: transaction.userId,
                  mobileNumber: transaction.mobileNumber,
                  scanPersonName: transaction.scanPersonName,
                  remarks: transaction.remarks,
                  createdAt: transaction.createdAt,
                  updatedAt: transaction.updatedAt,
                );
              },
            );
          } else {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _showNoDataDialog());
            return const Center(
                child: Text(
              'No data available!!',
            ));
          }
        },
      ),
    );
  }

  Future<TransactionHistoryResponse> fetchTransactionHistory(
      int selectedMonth) async {
    final url = Uri.parse('https://olx.makelink.in/api/transaction/history');
    var token = await getAccessToken();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var queryParams = {
      'month': selectedMonth.toString(),
      'year': DateTime.now().year.toString(),
    };

    final uri = Uri.https(url.authority, url.path, queryParams);

    try {
      var response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Print response body
        return TransactionHistoryResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load transaction history');
      }
    } catch (e) {
      throw Exception('Failed to load transaction history: $e');
    }
  }
}

class TransactionUI extends StatelessWidget {
  final int id;
  final String token;
  final String tokenId;
  final int? numberOf50Token;
  final int? numberOf100Token;
  final int tokenValue;
  final String side;
  final String userId;
  final int mobileNumber;
  final String scanPersonName;
  final String? remarks;
  final String createdAt;
  final String updatedAt;

  TransactionUI({
    required this.id,
    required this.token,
    required this.tokenId,
    this.numberOf50Token,
    this.numberOf100Token,
    required this.tokenValue,
    required this.side,
    required this.userId,
    required this.mobileNumber,
    required this.scanPersonName,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap with SingleChildScrollView
      scrollDirection: Axis.horizontal, // Scroll horizontally
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: $id',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('Token: $token'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Token ID: $tokenId'),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('Token Value: $tokenValue'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Side: $side'),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('User ID: $userId'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mobile Number: $mobileNumber'),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('Scan Person Name: $scanPersonName'),
                ],
              ),
              if (numberOf50Token != null)
                Text('Number of 50 Tokens: $numberOf50Token'),
              if (numberOf100Token != null)
                Text('Number of 100 Tokens: $numberOf100Token'),
              if (remarks != null) Text('Remarks: $remarks'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Created At: $createdAt'),
                  Text('Updated At: $updatedAt'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
