import 'package:shared_preferences/shared_preferences.dart';

Future<String> readPreferenceString(keyInput) async {
  final prefs = await SharedPreferences.getInstance();
  final key = keyInput;
  final value = prefs.getString(key) ?? null;
 
  return Future.value(value);
}

Future<bool> savePreferenceString(keyInput,valueInput) async {
  final prefs = await SharedPreferences.getInstance();
  final key = keyInput;
  final value = valueInput;
  prefs.setString(key, value);

  return Future.value(true);
  
}
