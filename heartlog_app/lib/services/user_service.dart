import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  SharedPreferences? _prefs;

  factory UserService() => _instance;
  UserService._internal();

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> get hasCompletedOnboarding async {
    final p = await prefs;
    return p.getBool('hasCompletedOnboarding') ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    final p = await prefs;
    await p.setBool('hasCompletedOnboarding', value);
  }

  Future<String> get name async {
    final p = await prefs;
    return p.getString('userName') ?? 'Ronny';
  }

  Future<void> setName(String value) async {
    final p = await prefs;
    await p.setString('userName', value);
  }

  Future<int?> get age async {
    final p = await prefs;
    return p.getInt('userAge');
  }

  Future<void> setAge(int value) async {
    final p = await prefs;
    await p.setInt('userAge', value);
  }

  Future<Map<String, dynamic>> getUserData() async {
    return {
      'name': await name,
      'age': await age,
    };
  }
}
