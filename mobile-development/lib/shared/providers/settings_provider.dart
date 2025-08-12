import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/constants.dart';

class SettingsProvider extends ChangeNotifier {
  bool _musicEnabled = true;
  bool _soundEnabled = true;
  SharedPreferences? _prefs;

  bool get musicEnabled => _musicEnabled;
  bool get soundEnabled => _soundEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _musicEnabled = _prefs?.getBool(AppConstants.musicEnabledKey) ?? true;
    _soundEnabled = _prefs?.getBool(AppConstants.soundEnabledKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleMusic() async {
    _musicEnabled = !_musicEnabled;
    await _prefs?.setBool(AppConstants.musicEnabledKey, _musicEnabled);
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    await _prefs?.setBool(AppConstants.soundEnabledKey, _soundEnabled);
    notifyListeners();
  }

  Future<void> setMusic(bool enabled) async {
    if (_musicEnabled != enabled) {
      _musicEnabled = enabled;
      await _prefs?.setBool(AppConstants.musicEnabledKey, _musicEnabled);
      notifyListeners();
    }
  }

  Future<void> setSound(bool enabled) async {
    if (_soundEnabled != enabled) {
      _soundEnabled = enabled;
      await _prefs?.setBool(AppConstants.soundEnabledKey, _soundEnabled);
      notifyListeners();
    }
  }
}
