import 'package:shared_preferences/shared_preferences.dart';

Future<int> getStoredMonth() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('month') ?? 0; // Return 0 if month is not found
}

Future<int> getStoredYear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('year') ?? 0; // Return 0 if year is not found
}
